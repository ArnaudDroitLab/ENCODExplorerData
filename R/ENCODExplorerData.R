#' ENCODExplorerData
#'
#' @name ENCODExplorerData
#' @docType package
NULL

#' Metadata for the files made available by ENCODE database as a 
#' \code{\link{data.table}} object. See \code{inst/scripts/make-data.R}
#' for the generation process.
#
#' The tables were generated with the \code{fetch_and_clean_raw_ENCODE_tables} function.
#'
#' @seealso \code{\link{get_encode_types}} to get a list of possible types. Note
#'   that some of the types are empty tables that are not included in the
#'   database created with \code{\link{fetch_and_clean_raw_ENCODE_tables}} function.
#' 
#' @name encode_df_lite
#' @format A data table
#' @examples
#'     library(AnnotationHub)
#'     hub <- AnnotationHub()
#'     myfiles <- query(hub, c("ENCODExplorerData", "Light"))
#'     myfiles[[1]]
NULL

#' Extended metadata for the files made available by ENCODE database as a 
#' \code{\link{data.table}} object. See \code{inst/scripts/make-data.R}
#' for the generation process.
#'
#' @name encode_df_full
#' @format A data table
#' @examples
#'     library(AnnotationHub)
#'     hub <- AnnotationHub()
#'     myfiles <- query(hub, c("ENCODExplorerData", "Full"))
#'     myfiles[[1]]
NULL