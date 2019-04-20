#' ENCODExplorerData
#'
#' @name ENCODExplorerData
#' @docType package
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