encode_lite_metadata_df = data.frame(
    Title="ENCODE File Metadata (Light)",
    Description="A data-frame containing a curated selection of metadata describing all files made available by the ENCODE project.",
    BiocVersion="3.9",
    Genome=NA,
    SourceType=NA,
    SourceUrl=NA,
    SourceVersion=NA,
    Species=NA,
    TaxonomyId=NA,
    Coordinate_1_based=NA,
    DataProvider="ENCODE Project",
    Maintainer="Eric Fournier <Fournier.Eric.2@crchudequebec.ulaval.ca>",
    RDataClass="data.frame",
    DispatchClass="Rda",
    RDataPath="", # TODO: fill this out once data have been uploaded to S3.
    Tags="ENCODE")
    
encode_full_metadata_df = data.frame(
    Title="ENCODE File Metadata (Full)",
    Description="A data-frame containing a large selection of metadata describing all files made available by the ENCODE project.",
    BiocVersion="3.9",
    Genome=NA,
    SourceType=NA,
    SourceUrl=NA,
    SourceVersion=NA,
    Species=NA,
    TaxonomyId=NA,
    Coordinate_1_based=NA,
    DataProvider="ENCODE Project",
    Maintainer="Eric Fournier <Fournier.Eric.2@crchudequebec.ulaval.ca>",
    RDataClass="data.frame",
    DispatchClass="Rda",
    RDataPath="", # TODO: fill this out once data have been uploaded to S3.
    Tags="ENCODE")    
    
write(rbind(encode_lite_metadata_df, encode_full_metadata_df), file="inst/extdata/metadata.csv", header=TRUE)