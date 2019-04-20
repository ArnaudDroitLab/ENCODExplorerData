#' ENCODExplorerData
#'
#' This package aims to ease access to ENCODE file metadata by converting them
#' into an easy-to-use data.table.
#'
#' The main feature of ENCODExplorerData are the two ENCODE file metadata data 
#' tables exported though AnnotationHub, \code{\link{encode_df_lite}} 
#' and \code{\link{encode_df_full}}). 
#' While these can be accessed directly like any other data.table, we recommend 
#' using the
#' \href{http://www.bioconductor.org/packages/release/bioc/html/ENCODExplorer.html}{ENCODExplorer}
#' companion package, which contains utility functions
#' for querying them, using the online ENCODE search function, downloading 
#' selected files, and retrieving control-treatment experimental designs from 
#' ENCODE.
#'
#' This package also exposes functions for regenerating up-to-date versions
#' of the metadata tables. See the \code{\link{fetch_and_clean_raw_ENCODE_tables}},
#' \code{\link{generate_encode_df_lite}} and \code{\link{generate_encode_df_full}}
#' functions for more details.
#'
#' @name ENCODExplorerData
#' @docType package
#' @seealso \code{\link{encode_df_lite}},
#'   \code{\link{encode_df_full}},
#'   \code{\link{fetch_and_clean_raw_ENCODE_tables}},
#'   \code{\link{generate_encode_df_lite}},
#'   \code{\link{generate_encode_df_full}}
NULL

#' ENCODE file metadata, Light version
#'
#' Metadata for the files made available by ENCODE database as a 
#' \code{\link[data.table]{data.table}} object. See \code{inst/scripts/make-data.R}
#' for the generation process. \code{encode_df_lite} contains a curated
#' subset of the full metadata and is faster to load and easier to work
#' with than \code{\link{encode_df_full}}.
#'
#' @name encode_df_lite
#' @format A data table
#' @examples
#'     # You can use AnnotationHub to retrieve encode_df_lite.
#'     library(AnnotationHub)
#'     hub <- AnnotationHub()
#'     myfiles <- subset(hub, title=="ENCODE File Metadata (Light, 2019-04-12 build)")
#'
#'     # You can then have a look at the metadata of the retrieved object.
#'     myfiles
#'
#'     # Finally, you can access the data.table itself by indexing into the 
#'     # object returned by subset.
#'     myfiles[[1]]
#' @seealso \code{\link{generate_encode_df_lite}}, \code{\link{encode_df_full}}
NULL

#' ENCODE file metadata, Full version
#'
#' Metadata for the files made available by ENCODE database as a 
#' \code{\link{data.table}} object. See \code{inst/scripts/make-data.R}
#' for the generation process. \code{encode_df_full} contains all processed
#' metadata columns, including content md5sums, cloud URLs, etc.
#' Operations on \code{encode_df_full} will take longer than those on 
#' \code{\link{encode_df_lite}}, but may be required if some of the extra 
#' metadata columns are necessary for your needs.
#'
#' @name encode_df_full
#' @format A data table
#' @examples
#'     # You can use AnnotationHub to retrieve encode_df_full.
#'     library(AnnotationHub)
#'     hub <- AnnotationHub()
#'     myfiles <- subset(hub, title=="ENCODE File Metadata (Full, 2019-04-12 build)")
#'
#'     # You can then have a look at the metadata of the retrieved object.
#'     myfiles
#'
#'     # Finally, you can access the data.table itself by indexing into the 
#'     # object returned by subset.
#'     myfiles[[1]]
#' @seealso \code{\link{generate_encode_df_full}}, \code{\link{encode_df_lite}}
NULL