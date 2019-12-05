#' Extract a data.frame corresponding to a table in ENCODE database
#'
#' @param type The type of table to extract from the ENCODE rest api.
#'             Available types can be obtained using 
#'             \code{\link{get_encode_types}}.
#' @return a \code{data.frame} corresponding to the table asked. If no match is
#'         found, returns an empty \code{data.frame}
#'         
#' @importFrom jsonlite fromJSON
#' @import RCurl
#' @keywords internal
fetch_table_from_ENCODE_REST <- function(type) {
  filters = "&limit=all"
  filters = paste0(filters, "&frame=object&format=json")
  
  url <- "https://www.encodeproject.org/search/?type="
  url <- paste0(url, type, filters)
  results <- data.frame()
  
  if (RCurl::url.exists(url)) {
    res <- jsonlite::fromJSON(url)
    if (res[["notification"]] == "Success") {
      results <- res[["@graph"]]
    }
  } else {
    
    temp <- strsplit(type, split="_")[[1]]
    utype <- vapply(temp,function(x){paste0(toupper(substr(x,1,1)),
                                           substr(x,2,nchar(x)))},
                    character(1L))
    utype <- paste(utype, collapse='')
    url <- "https://www.encodeproject.org/search/?type="
    url <- paste0(url, utype, filters)

    if (RCurl::url.exists(url)) {
      res <- jsonlite::fromJSON(url)
      if (res[["notification"]] == "Success") {
        results <- res[["@graph"]]
      }
    }
  }
  
  return(results)
}

#' Clean a data.frame that was produced by fetch_table_from_ENCODE_REST
#'
#' \code{data.frame}s produced when converting JSON to \code{data.frame} with
#' the \code{fromJSON} function will sometime have columns that are lists
#' and/or columns that are \code{data.frames}.
#'
#' This function will either remove columns that are not relevant and convert
#' columns to a vector or data.frame.
#'
#' @param table The table produced by the \code{fetch_table_from_ENCODE_REST} function.
#'
#' @return a \code{data.frame} corresponding to the cleaned version of the
#' input \code{data.frame}.
#' @examples
#'   clean_table(ENCODExplorerData:::fetch_table_from_ENCODE_REST("award"))
#' @export
clean_table <- function(table) {

    class_vector <- as.vector(vapply(table, class, character(1L)))
    good_class = class_vector %in% c("character", "list", "data.frame",
                                        "logical", "numeric", "integer")
    table <- table[,good_class]
    table_names <- gsub("@", "", colnames(table))
    table <- lapply(colnames(table), clean_column, table)
    names(table) <- table_names
    table[vapply(table, is.null, logical(1L))] <- NULL
    result <- data.frame(table, stringsAsFactors = FALSE)
}

#' Extract the schemas from ENCODE's github
#'
#' The JSONs are fetched from:
#'        https://github.com/ENCODE-DCC/encoded/tree/master/src/encoded/schemas
#'
#' The data is extracted using the github api:
#'         https://developer.github.com/guides/getting-started/
#'
#' The data is then downloaded using the \code{jsonlite} package.
#'
#' @return a \code{list} of schemas.
#' @examples
#'   ENCODExplorerData:::get_schemas()
#' @importFrom jsonlite fromJSON
#' @export
get_schemas <- function() {
  urls <- get_schema_urls()
  # We need to suppress warnings:
  #         Unexpected Content-Type: text/plain; charset=utf-8
  schema_json <- suppressWarnings(lapply(urls, jsonlite::fromJSON))
  schema_json
}

#' Returns the URLs for downloading the XML schemas from ENCODE's github.
#'
#' @return a \code{character} \code{vector} of schema download URLs.
#' @examples
#'   ENCODExplorerData:::get_schema_urls()
#' @importFrom jsonlite fromJSON
#' @export
get_schema_urls <- function() {
  encode_api_url <- "https://api.github.com/repos"
  encoded_repo <- "encode-dcc/encoded"
  schemas <- "src/encoded/schemas"
  url <- paste(encode_api_url, encoded_repo, "contents", schemas, sep = "/")
  schema_info <- jsonlite::fromJSON(url)
  
  schema_urls = schema_info$download_url
  names(schema_urls) = schema_info$name
  
  return(schema_urls[!is.na(schema_urls)])
}

#' A list of known tables from ENCODE database.
#'
#' The type (table) names are extracted from the schema list from ENCODE-DCC
#' github repository:
#'        https://github.com/ENCODE-DCC/encoded/tree/master/src/encoded/schemas
#'
#' The data is extracted using the github api:
#'         https://developer.github.com/guides/getting-started/
#'
#' @return a vector of \code{character} with the names of the known tables in
#'         the ENCODE database.
#'
#' @examples
#'    get_encode_types()
#' @import tools
#' @export
get_encode_types <- function() {
  encode_api_url <- "https://api.github.com/repos"
  encoded_repo <- "encode-dcc/encoded"
  schemas <- "src/encoded/schemas"
  url <- paste(encode_api_url, encoded_repo, "contents", schemas, sep = "/")
  schema_names <- jsonlite::fromJSON(url)$name
  schema_names <- schema_names[grepl(".json$", schema_names)]
  tools::file_path_sans_ext(schema_names)
}


# Collapse a vector/list of primitive types into a vector.
# If the input value is empty, return NA.
# If all elements are identical, return that element.
# If there are multiple elements, collapse them.
paste_or_na = function(x) {
    if (length(x) > 0) {
        if(length(unique(unlist(x))) == 1) {
            # Sometimes we deal with lists, sometimes vectors.
            # Make sure we index into those correctly to retrieve a single
            # element, rather than a length-1 list.
            ifelse(is.list(x), x[[1]][1], x[1])
        } else {
            # Collapse multiple different elements.
            paste(x, collapse="; ")
        }
    } else {
        # If there are no elements, return NA, not NULL.
        NA
    }
}

#' Clean a single column of a flattened data.frame returned by ENCODE.
#'
#' The input column can either be a data.frame, a vector of character, a vector
#' of numeric or a list of one the previous type.
#'
#' This function will either remove columns that are not relevant and convert
#' columns to a vector or data.frame.
#'
#' @param column_name The name of the column to be processed.
#' @param table The table produced by the \code{fetch_table_from_ENCODE_REST} 
#'              function.
#'
#' @return A flat column or columns to be cbind'ed into the final data.frame.
#' @importFrom methods is
#' @keywords internal
clean_column <- function(column_name, table) {
    stopifnot(is.character(column_name))
    stopifnot(column_name %in% colnames(table))
    stopifnot(length(column_name) == 1)
    stopifnot(is.data.frame(table))
    stopifnot(nrow(table) >= 1)
    
    column = clean_column_internal(table[[column_name]], nrow(table), column_name)

    type <- c("character", "data.frame", "logical",
              "numeric", "integer", "NULL")
    stopifnot(class(column) %in% type)
    if(methods::is(column, "data.frame")) {
        stopifnot(nrow(column) == nrow(table))
    }else if((class(column) %in% type) & !(is.null(column))){
        stopifnot(length(column) == nrow(table))
    }
    
    column
}

# Workhorse cleaning function.
#
# - We return primitive numeric, logical or character columns as-is.
# - List columns are "flattened" into a vector if all of their elements consist
#   of a single type. 
# - If all elements of a list column are data-frames, we extract and flattened
#   all identically named columns as if they were a list of primitive types.
clean_column_internal = function(column, expected_nrow, column_name) {
    if(is.list(column)) {
        # Special case if all list elements are data-frames, then
        # combine identical columns.
        if(all(unlist(lapply(column, is.data.frame)))) {
            # Identify all unique column names.
            unique_colnames = unique(unlist(lapply(column, colnames)))
            names(unique_colnames) = unique_colnames
            
            # Collapse all unique columns into vectors.
            new_columns = lapply(unique_colnames, function(x) {
                # Extract values from the columns of each individual data.frame
                list_of_values = lapply(column, "[[", x)
                # Collapse the values into a vector of scalar primitives.
                collaped_values = lapply(list_of_values, function(y) {
                    # Sometimes, we'll have a list here. From the top, we have:
                    #   JSON Table as data.frame
                    #    +-> Column which is a list of data.frames
                    #         +-> Column which is a list of scalar
                    if(is.list(y))
                        y = unlist(y)
                    paste_or_na(y)
                })
                unlist(collaped_values)
            })
            
            # Convert the columns to a data.frame so they can be cbind'ed/
            # constructed into a data.frame.
            return(data.frame(new_columns, check.names=FALSE))
        } else {
            # List of primitive types: collapse individual elements
            # with paste(collapse=TRUE), substituting NA instead of NULL
            # when the list is empty.
            col_as_string = unlist(lapply(column, paste_or_na))
            col_as_string = gsub('"', '', gsub("c\\((.+?)\\);", "\\1;", col_as_string))
            return(col_as_string)
        }
    } else {
        # Columns of primitive scalar types are returned as-is.
        return(column)
    }
}
