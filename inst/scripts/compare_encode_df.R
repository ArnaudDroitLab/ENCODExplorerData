# Utilitty function for comparing two versions of encode_df.
compare_encode_df <- function(encode_df_1, encode_df_2, 
                              label_1="encode_df_1", label_2="encode_df_2") {
    cat(label_1, " has the following extra columns:\n",
        setdiff(colnames(encode_df_1), colnames(encode_df_2)), "\n")
    cat(label_2, " has the following extra columns:\n",
        setdiff(colnames(encode_df_2), colnames(encode_df_1)), "\n")        
        
    for(i in intersect(colnames(encode_df_1), colnames(encode_df_2))) {
        comp_res = encode_df_1[[i]] == encode_df_2[[i]] | 
                   is.na(encode_df_1[[i]]) & is.na(encode_df_2[[i]])
        comp_res[is.na(comp_res)] = FALSE
        if(all(comp_res)) {
            cat("Column ", i, " matches.\n")
        } else {
            n_mismatch = sum(!comp_res, na.rm=TRUE)
            
            cat("Column ", i, " has ", n_mismatch, " mismatching entries.\n")
            
            if(all(is.na(encode_df_1[[i]][!comp_res]) & (encode_df_2[[i]][!comp_res] == "NA")) ||
               all(is.na(encode_df_2[[i]][!comp_res]) & (encode_df_1[[i]][!comp_res] == "NA"))) {
                cat('Mismatched stringified "NA" to real primitive NA\n')
            
            } else {
                cat("First 10 mismatches:\n")
                first_mismatch = which(!comp_res)[1:(min(n_mismatch, 10))]
                comp_df = data.frame(encode_df_1=substr(encode_df_1[[i]][first_mismatch], 1, 40),
                                     encode_df_2=substr(encode_df_2[[i]][first_mismatch], 1, 40))
    
                colnames(comp_df) = c(label_1, label_2)
                print(comp_df)
            }
        }
    }
}

compare_encode_df_cache <- function(cache_path_1, cache_path_2, 
                                    label_1="encode_df_1", label_2="encode_df_2") {
    load(cache_path_1)
    encode_df_1  = encode_df_full
    
    load(cache_path_2)
    encode_df_2  = encode_df_full
    
    compare_encode_df(encode_df_1, encode_df_2, label_1, label_2)
}
