encode_lite_metadata_df = data.frame(
    Title="ENCODE File Metadata (Light, 2019-04-12 build)",
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
    RDataClass="data.table",
    DispatchClass="Rda",
    RDataPath="ENCODExplorerData/encode_df_lite.rda", # TODO: fill this out once data have been uploaded to S3.
    Tags="ENCODE")
    
encode_full_metadata_df = data.frame(
    Title="ENCODE File Metadata (Full, 2019-04-12 build)",
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
    RDataClass="data.table",
    DispatchClass="Rda",
    RDataPath="ENCODExplorerData/encode_df_full.rda", # TODO: fill this out once data have been uploaded to S3.
    Tags="ENCODE")    
    
write.csv(rbind(encode_lite_metadata_df, encode_full_metadata_df), file="metadata.csv", row.names=FALSE)