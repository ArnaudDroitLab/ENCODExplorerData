# prepare_ENCODEdb fetches the metadata tables from ENCODE and
# store them as data.frame objects.
tables = ENCODExplorerData::prepare_ENCODEdb("tables.rda")

# export_ENCODEdb_matrix_lite stitches together the many tables 
# by performing left_joins where appropriate.
encode_dfs = ENCODExplorerData::export_ENCODEdb_matrix_lite(tables)

# Write out encode_df_lite, which contains a limited,
# curated set of metadata.
encode_df_lite = encode_dfs$encode_df
save(encode_df_lite, file="encode_df_lite.rda", compress="xz", compression_level=9)

# Write out encode_df_full, which contains all processed metadata
# columns.
encode_df_full = do.call(cbind, encode_dfs)
save(encode_df_full, file="encode_df_full.rda", compress="xz", compression_level=9)

