#' ENCODExplorerData
#'
#' @name ENCODExplorerData
#' @docType package
NULL

#' Metadata for the files made available by ENCODE database as a 
#' \code{\link{data.table}} object. See \code{inst/scripts/make-data.R}
#' for the generation process.
#
#' The tables were generated with the \code{prepare_ENCODEdb} function.
#'
#' @seealso \code{\link{get_encode_types}} to get a list of possible types. Note
#'   that some of the types are empty tables that are not included in the
#'   database created with \code{\link{prepare_ENCODEdb}} function.
#' 
#' @name encode_df_lite
#' @format A data table
#' @examples
#'   \dontrun{
#'     library(AnnotationHub)
#'     hub <- AnnotationHub()
#'     myfiles <- query(hub, "ENCODE File Metadata (Light, 2019-04-12 build)")
#'     myfiles[[1]]
#'   }
NULL

#' Extended metadata for the files made available by ENCODE database as a 
#' \code{\link{data.table}} object. See \code{inst/scripts/make-data.R}
#' for the generation process.
#'
#' @name encode_df_full
#' @format A data table
#' @examples
#'   \dontrun{
#'     library(AnnotationHub)
#'     hub <- AnnotationHub()
#'     myfiles <- query(hub, "ENCODE File Metadata (Full, 2019-04-12 build)")
#'     myfiles[[1]]
#'   }
NULL