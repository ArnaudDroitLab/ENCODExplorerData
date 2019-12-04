# fetch_and_clean_raw_ENCODE_tables fetches the various metadata tables from 
# ENCODE (files, biosamples, treatments, etc.) and store them as data.frame 
# objects.
tables = ENCODExplorerData::fetch_and_clean_raw_ENCODE_tables("tables.rda", precache=".")

# build_file_db_from_raw_tables stitches together the many tables 
# by performing left_joins where appropriate.
encode_df_lite = ENCODExplorerData::generate_encode_df_lite(tables)

# Write out encode_df_lite, which contains a limited,
# curated set of metadata.
save(encode_df_lite, file="encode_df_lite.rda", compress="xz", compression_level=9)

# Write out encode_df_full, which contains all processed metadata
# columns.
encode_df_full = ENCODExplorerData::generate_encode_df_full(tables)
save(encode_df_full, file="encode_df_full.rda", compress="xz", compression_level=9)

