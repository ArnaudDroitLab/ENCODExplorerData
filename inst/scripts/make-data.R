tables = ENCODExplorerData::prepare_ENCODEdb("tables.rda")
encode_dfs = export_ENCODEdb_matrix_lite(tables)

encode_df_lite = encode_dfs$encode_df
save(encode_df_lite, "encode_df_lite.rda")

encode_df_full = do.call(cbind, encode_dfs)
save(encode_df_lite, "encode_df_full.rda")

