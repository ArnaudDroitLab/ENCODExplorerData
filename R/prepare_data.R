#' Fetches and preprocess the raw metadata tables from ENCODE.
#' 
#' @param cache_filename A file name for caching the selected tables into.
#' @param types The names of the tables to extract using the ENCODE rest api.
#' @param overwrite If cache_filename already exists, should it be overwritten?
#'   Default: \code{FALSE}.
#' @param precache A path to cache the raw metadata as returned by ENCODE and
#'                 parsed using jsonlite. If NULL, no caching is performed.
#'   Default: \code{FALSE}.
#'
#' @return A \code{list} with all selected tables from ENCODE.
#' 
#' @examples
#' fetch_and_clean_raw_ENCODE_tables(cache_filename = "platform.RDA", types = "platform")
#' file.remove("platform.RDA")
#'     
#' @import data.table
#' @export
fetch_and_clean_raw_ENCODE_tables <- function(cache_filename = "tables.RDA",
                             types = get_encode_types(), overwrite = FALSE,
                             precache=NULL) {
  if(file.exists(cache_filename) && !overwrite) {
    warning(paste0("The file ", cache_filename, " already exists and will not be overwritten.\n",
                   "Please delete it or set overwrite = TRUE before re-running the data preparation"))
    NULL
  } else {
    # List of data.frame
    tables <- lapply(types, fetch_single_table, precache=precache)
    
    # Return the named tables
    names(tables) <- types
    tables[vapply(tables, is.null, logical(1L))] <- NULL
    tables <- lapply(tables, as.data.table)
    save(tables, file=cache_filename)
   
    # Extract data from the DB
    if(length(tables) > 0) {
      invisible(tables)
    }
    else
    {
      warning(paste0("Something went wrong during data preparation. ",
                     "Please erase the database ", cache_filename, " and re-run the whole process.",
                     "If the problem persists, please contact us"))
      NULL
    }
    
  }
}

# Download, cache and clean a single ENCODE table.
fetch_single_table <- function(type, precache) {
    res=NULL
    cat("Extracting table", type, "\n")
    
    # Determine if a cached table exists, and it it does, load it.
    if(!is.null(precache)) {
        precache_path = file.path(precache, paste0(type, ".rds"))
        if(file.exists(precache_path)) {
            res = readRDS(precache_path)
        }
    }
    
    # If no cache exists or caching is turned off, fetch the table from ENCODE.
    if(is.null(res)) {
        res <- fetch_table_from_ENCODE_REST(type)
    }
    
    # Save the unmodified table if caching is turned on.
    if(!is.null(precache)) {
        saveRDS(res, file=file.path(precache, paste0(type, ".rds")))
    }
    
    # Clean the table if it is non-empty.
    if(ncol(res) == 0) {
        res = NULL
    } else {
        cat("Cleaning table", type, "\n")
        res <- clean_table(jsonlite::flatten(res))
    }
    
    return(res)
}

#' Extract file metadata from the full set of ENCODE metadata tables.
#'
#' @return A \code{list} containing two \code{data.table} objects:
#'   \code{encode_df}, containing the most interesting metadata columns,
#'   and \code{encode_df_ext}, containing relevant metadata for all
#'   ENCODE files.
#'
#' @param tables A list of ENCODE metadata tables as loaded by
#'   fetch_and_clean_raw_ENCODE_tables.
#'
#' @examples
#'     \dontrun{
#'         tables = fetch_and_clean_raw_ENCODE_tables()
#'         build_file_db_from_raw_tables(tables = tables)
#'     }
#' @keywords internal
build_file_db_from_raw_tables <- function(tables) {
  db = tables
  encode_df = db$file
  
  # Renaming certain column.
  encode_df <- rename_file_columns(encode_df)
  encode_df <- split_dataset_column(files = encode_df)
  
  # Merge sample information from other tables.
  encode_df <- update_project_platform_lab(files = encode_df, awards = db$award, 
                                           labs = db$lab, platforms = db$platform)
  encode_df <- update_replicate(files = encode_df, replicates = db$replicate)
  encode_df <- update_antibody(files = encode_df, antibody_lot = db$antibody_lot,
                               antibody_charac = db$antibody_characterization)
  encode_df <- update_treatment(files = encode_df, treatments = db$treatment,
                               libraries = db$library, biosamples = db$biosample,
                               replicates = db$replicate, datasets=db$dataset)
  encode_df = update_experiment(files=encode_df, experiments=db$experiment)
  encode_df = update_biosample_types(files=encode_df, biosample_types=db$biosample_type)
  encode_df = update_target(files=encode_df, targets=db$target, organisms=db$organism)
                 

  # Fetch some additional miscellaneous columns.                 
  encode_df$nucleic_acid_term = pull_column(encode_df, db$library, "replicate_libraries", "id", "nucleic_acid_term_name")
  encode_df$submitted_by <- pull_column_merge(encode_df, db$user, "submitted_by", "id", "title", "submitted_by")
  encode_df$status <- pull_column_merge(encode_df, db$dataset, "accession", "accession", "status", "status")
  encode_df <- file_size_conversion(encode_df)
  
  # Remove remaining ID prefixes
  encode_df$replicate_libraries <- remove_id_prefix(encode_df$replicate_libraries)                               
  encode_df$controls <- remove_id_prefix(encode_df$controls)
  encode_df$controlled_by <- remove_id_prefix(encode_df$controlled_by)
  encode_df$replicate_list <- remove_id_prefix(encode_df$replicate_list)
  
  # Ordering the table by the accession column
  encode_df <- encode_df[order(encode_df$accession),]
  
  # Split the table into encode_df_lite and encode_df_full.
  return(subset_final_columns(encode_df))
}

# Reorder columns, and define the subsets for encode_df_lite
# and encode_df_full.
subset_final_columns <- function(encode_df) {
  # Reordering the table, we want to have the column below as the first columna
  # to be display followed by the rest the remaining columns.
  main_columns <- c("accession", "file_accession", "file_type", "file_format",
                    "file_size", "output_category", "output_type", "target", "investigated_as",
                    "nucleic_acid_term", "assay", "treatment_id", "treatment", "treatment_amount",
                    "treatment_amount_unit", "treatment_duration", "treatment_duration_unit",
                    "treatment_temperature", "treatment_temperature_unit", "treatment_notes",
                    "biosample_id", "biosample_type", "biosample_name", 
                    "dataset_biosample_summary", "dataset_description",
                    "replicate_libraries", "replicate_antibody", "antibody_target",
                    "antibody_characterization", "antibody_caption", 
                    "organism", "dataset_type", "assembly","status", 'controls', "controlled_by",
                    "lab","run_type", "read_length", "paired_end",
                    "paired_with", "platform", "href", "biological_replicates",
                    "biological_replicate_number","technical_replicate_number","replicate_list",
                    "technical_replicates", "project", "dataset", "dbxrefs", "superseded_by",
                    "file_status", "submitted_by", "library", "derived_from",
                    "file_format_type", "file_format_specifications", "genome_annotation",
                    "external_accession", "date_released", "biosample_ontology", "md5sum")
  other_columns = setdiff(colnames(encode_df), main_columns)
  
  # Protect against columns that might no longer part of the ENCODE metadata.
  missing_columns = setdiff(main_columns, colnames(encode_df))
  if(length(missing_columns) != 0) {
      message("Some expected columns are no longer present within ENCODE metadata.")
      message("Missing columns: ", paste(missing_columns, collapse=", "))
  }
  
  encode_df_lite = encode_df[,intersect(main_columns, colnames(encode_df)), with=FALSE]
  encode_df_ext = encode_df[,other_columns, with=FALSE]

  return(list(encode_df=encode_df_lite, 
              encode_df_ext=encode_df_ext))
}

#' Extract file metadata from the full set of ENCODE metadata tables.
#'
#' @return a \code{data.table} containing relevant metadata for all
#'   ENCODE files.
#'
#' @param tables A list of ENCODE metadata tables as loaded by
#'   fetch_and_clean_raw_ENCODE_tables.
#'
#' @examples
#'     \dontrun{
#'         tables = fetch_and_clean_raw_ENCODE_tables()
#'         export_ENCODEdb_matrix(tables = tables)
#'     }
#' 
#' @export
generate_encode_df_lite <- function(tables) {
    split_df = build_file_db_from_raw_tables(tables)
    return(split_df$encode_df)
}

#' Given the raw ENCODE tables, this generate a data.table with the
#' full set of file metadata columns.
#'
#' @return a \code{data.table} containing relevant metadata for all
#'   ENCODE files.
#'
#' @param tables A list of ENCODE metadata tables as loaded by
#'   fetch_and_clean_raw_ENCODE_tables.
#'
#' @examples
#'     \dontrun{
#'         tables = fetch_and_clean_raw_ENCODE_tables()
#'         export_ENCODEdb_matrix(tables = tables)
#'     }
#' 
#' @export
generate_encode_df_full <- function(tables) {
    all_tables = build_file_db_from_raw_tables(tables)
    # Set names to NULL, or they will be prepended to the resulting
    # column names.
    names(all_tables) = NULL
    return(do.call(cbind, all_tables))
}

pull_column_id <- function(ids, table2, id2, pulled_column) {
    return(table2[[pulled_column]][match(ids, table2[[id2]])])
}

# Matches the entries of table1 to table2, using id1 and id2, then returns
# the values from pulled_column in table2.
pull_column <- function(table1, table2, id1, id2, pulled_column) {
  return(pull_column_id(table1[[id1]], table2, id2, pulled_column))
}

# Matches the entries of table1 to table2, using id1 and id2, then returns
# a merged vector containing the values from pulled_column in table2 when
# a match exists, or table1$updated_value if it does not.
pull_column_merge <- function(table1, table2, id1, id2, pulled_column, updated_value) {
  retval = pull_column(table1, table2, id1, id2, pulled_column)
  retval = ifelse(is.na(match(table1[[id1]], table2[[id2]])), table1[[updated_value]], retval)
  return(retval)
}

# Matches the entries of table1 to table2, using id1 and id2,
# then creates a new data.table from the column pairings described in
# value_pairs. Ex: c("antibody_target"="target") will create a column
# named "antibody_target" from table2$target. (Similar to dplyr::*_join)
#' @import data.table
pull_columns <- function(table1, table2, id1, id2, value_pairs) {
    retval <- NULL
    for(i in seq_along(value_pairs)) {
        value_name = value_pairs[i]
        out_name = ifelse(is.null(names(value_pairs)), value_name, names(value_pairs)[i])
        out_name = ifelse(out_name=="", value_name, out_name)
        if(is.null(retval)) {
            retval = data.table::data.table(pull_column(table1, table2, id1, id2, value_name))
            colnames(retval) = out_name
        } else {
            retval[[out_name]] = pull_column(table1, table2, id1, id2, value_name)
        }
    }
    return(retval)
}

# Calls pull_columns, and append the results to table1.
pull_columns_append <- function(table1, table2, id1, id2, value_pairs) {
    pulled_columns = pull_columns(table1, table2, id1, id2, value_pairs)
    return(cbind(table1, pulled_columns))
}

# Remove the type prefix from ENCODE URL-like identifiers.
# Example: /files/ENC09345TXW/ becomes ENC09345TXW.
remove_id_prefix <- function(ids) {
    return(gsub("/.*/(.*)/", "\\1", ids))
}

# Pulls a column. If no match is found, remove the ENCODE id type prefix
# from the previous value.
pull_column_no_prefix <- function(table1, table2, id1, id2, pull_value, prefix_value) {
    pulled_val = pull_column(table1, table2, id1, id2, pull_value)
    no_prefix = remove_id_prefix(table1[[prefix_value]])
    return(ifelse(is.na(pulled_val), no_prefix, pulled_val))
}

# Rename certain columns from the files table.
rename_file_columns <- function(files){
  names(files)[names(files) == 'status'] <- 'file_status'
  names(files)[names(files) == 'accession'] <- 'file_accession'
  names(files)[names(files) == 'award'] <- 'project'
  names(files)[names(files) == 'replicate'] <- 'replicate_list'
  
  return(files)
}

# Fetch information from the ENCODE award, lab and platform tables
# and merge them into encode_df (ENCODE's file table)
update_project_platform_lab <- function(files, awards, labs, platforms){
  # Updating files$project with awards$project
  files$project = pull_column_no_prefix(files, awards, "project", "id", "project", "project")
  
  # Updating files$paired_with
  files$paired_with <- remove_id_prefix(files$paired_with)
  
  # Updating files$platform with platform$title
  files$platform = pull_column_no_prefix(files, platforms, "platform", "id", "title", "platform")
  
  # Updating files$lab with labs$title
  files$lab = pull_column_no_prefix(files, labs, "lab", "id", "title", "lab")

  return(files)
}

# Fetches columns from ENCODE experiment table and merges them
# with encode_df (ENCODE's file table).
update_experiment <- function(files, experiments) {
  exp_colmap = c("target", "date_released", "status", "assay"="assay_title", "biosample_ontology",
                 "controls"="possible_controls", "dataset_biosample_summary"="biosample_summary",
                 "dataset_description"="description")
  files = pull_columns_append(files, experiments, "accession", "accession", exp_colmap)
  
  return(files)
}

# Fetches columns from ENCODE biosamples table and merges them
# with encode_df (ENCODE's file table).
update_biosample_types <- function(files, biosample_types) {
  bio_colmap = c("biosample_type"="classification", "biosample_name"="term_name")
  files = pull_columns_append(files, biosample_types, "biosample_ontology", "id", bio_colmap)
  
  return(files)
}

# Fetches columns from ENCODE replicate table and merges them
# with encode_df (ENCODE's file table).
update_replicate <- function(files, replicates) {
  # Updating biological_replicate_list with replicates$biological_replicate_number
  replicate_col_map = c("biological_replicate_number",
                        "replicate_antibody"="antibody","technical_replicate_number")
  files = pull_columns_append(files, replicates, "replicate_list", "id", replicate_col_map)
  
  return(files)
}

# Fetches columns from ENCODE antibody_lot and antibody_characterization tables
# and merge them with encode_df (ENCODE's file table).
update_antibody <- function(files, antibody_lot, antibody_charac) {
  # Creating antibody target
  antibody_col_map = c("antibody_target"="targets", "antibody_characterization"="characterizations")
  files = pull_columns_append(files, antibody_lot, "replicate_antibody", "id", antibody_col_map)
  
  files$antibody_caption = pull_column(files, antibody_charac, "antibody_characterization", "id", "caption")
  files$antibody_characterization = pull_column_merge(files, antibody_charac, "antibody_characterization", "id", "characterization_method", "antibody_characterization")

  files$replicate_antibody <- remove_id_prefix(files$replicate_antibody)
  files$antibody_target <- remove_id_prefix(files$antibody_target)  
  
  return(files)  
}

# Fetches columns from ENCODE treatment table and merge them with 
# encode_df (ENCODE's file table).
update_treatment <- function(files, treatments, libraries, biosamples, replicates, datasets) {
  # Infer the biosample id from replicate -> library -> biosample chain.
  files$biosample_id = pull_column(files, libraries, "replicate_libraries", "id", "biosample")
  
  # Sometimes the replicate id is unavailable. The biosample can still sometime be inferred
  # through the dataset -> replicate -> library -> biosample chain.
  replicate_lists = pull_column(files, datasets, "accession", "accession", "replicates")
  
  # A dataset has multiple replicates, and we don't know which one maps to our file.
  # But all replicates should come from the same biosample, so we'll pick the first one
  # on the list.
  first_replicates = unlist(lapply(strsplit(replicate_lists, ";"), function(x) {trimws(x[1])}))
  
  # From the first replicate, we derive the biosample id.
  library_ids = pull_column_id(first_replicates, replicates, "id", "library")
  biosample_ids = pull_column_id(library_ids, libraries, "id", "biosample")
  
  # Now merge those biosample ids with those already known.
  files$biosample_id = ifelse(is.na(files$biosample_id), biosample_ids, files$biosample_id)
  
  # Now that we have the biosample, we might as well grab the organism.
  files$organism = pull_column(files, biosamples, "biosample_id", "id", "organism")
  
  # From the biosample id, infer the treatment id.
  files$treatment_id = pull_column(files, biosamples, "biosample_id", "id", "treatments")
  
  # Infer term from id when available. Replace id with term.
  files$treatment = files$treatment_id
  files$treatment = pull_column_merge(files, treatments, "treatment_id", "id", "treatment_term_name", "treatment")
  

  
  treatment_col_map = c("treatment_amount"="amount", "treatment_amount_unit"="amount_units", 
                        "treatment_duration"="duration", "treatment_duration_unit"="duration_units",
                        "treatment_temperature"="temperature", "treatment_temperature_unit"="temperature_units",
                        "treatment_notes"="notes")
  files = pull_columns_append(files, treatments, "treatment_id", "id", treatment_col_map)

  return(files)
}

# Fetches columns from ENCODE target and organism tables and merge them with 
# encode_df (ENCODE's file table).
update_target <- function(files, targets, organisms) {
  files$organism <- pull_column_merge(files, targets, "target", "id", "organism", "organism")
  
  files$investigated_as = pull_column(files, targets, "target", "id", "investigated_as")                 
  files$target = pull_column_merge(files, targets, "target", "id", "label", "target")

  files$organism <- pull_column_merge(files, organisms, "organism", "id", "scientific_name", "organism")  
  
  return(files)
}

# Split the dataset column into its type and accession components.
split_dataset_column <- function(files){
  # Step 5 : Splitting dataset column into two column
  dataset_types <- gsub(x = files$dataset, pattern = "/(.*)/.*/", 
                        replacement = "\\1")
  dataset_accessions <- gsub(x = files$dataset, pattern = "/.*/(.*)/", 
                             replacement = "\\1")
  
  files <- cbind(accession = dataset_accessions, dataset_type = dataset_types, 
                 files)
  
  return(files)
}

# Converts file sizes from raw numbers to human readable format.
file_size_conversion <- function(encode_exp) {
    # Converting the file size from byte to the Kb, Mb or Gb
    encode_exp$file_size <- sapply(encode_exp$file_size, function(size){
        
        if(!(is.na(size))){
            if(size < 1024){
                paste(size,"b") 
            }else if ((size >= 1024) & (size < 1048576)){
                paste(round(size/1024,digits = 1), "Kb")
            }else if ((size >= 1048576) & (size < 1073741824)){
                paste(round(size/(1048576),digits = 1), "Mb")
            }else{
                paste(round(size/1073741824, digits = 2), "Gb")
            }
        }
    })
    encode_exp$file_size = as.character(encode_exp$file_size)
    encode_exp
}