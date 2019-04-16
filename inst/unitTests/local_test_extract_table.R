if(FALSE) {
  library( "RUnit" )
  library( "ENCODExplorerData" )
}

res = fetch_table_from_ENCODE_REST(type = "platform")
checkTrue(nrow(res) > 0, "this function should return an non empty data.frame")

res = fetch_table_from_ENCODE_REST(type = "test")
checkTrue(nrow(res) == 0, "this function should return an empty data.frame")
