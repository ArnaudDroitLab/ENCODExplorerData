if(FALSE) {
  library( "RUnit" )
  library( "ENCODExplorerData" )
}

test.column_character <- function() {
  load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
  exp <- c("a", "b", "c", NA)
  obs <- ENCODExplorerData:::clean_column("character", unitTest_df)
  checkIdentical(obs,exp)
}

test.column_numeric <- function () {
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    exp <- c(11, 22, 33, 44)
    obs <- ENCODExplorerData:::clean_column("numeric", unitTest_df)
    checkIdentical(obs, exp)
}

test.column_logical <- function (){
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    obs <- ENCODExplorerData:::clean_column("logical", unitTest_df)
    exp <- c(TRUE, FALSE, FALSE, TRUE)
    checkIdentical(exp,obs)
}

test.column_integer <- function () {
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    obs <- ENCODExplorerData:::clean_column("integer", unitTest_df)
    exp <- as.integer(c(5, 6, 7, 8))
    checkIdentical(obs, exp)
}

test.column_list_character <- function () {
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    obs <- ENCODExplorerData:::clean_column("list_char", unitTest_df)
    exp <- c("a; b", "c; d; e", NA, NA)
    checkIdentical(obs, exp)
}

test.column_list_dataFrame <- function () {
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    obs <- ENCODExplorerData:::clean_column("list_dFrame", unitTest_df)
    list_dFrame.experiment.sample = c(NA, NA, NA, "an experiment sample")
    list_dFrame.experiment.type = c(NA, NA, NA, "an experiement type")
    list_dFrame.replicate.experiment = c(NA, "a replicate experiment", NA, NA)
    list_dFrame.replicate.target = c(NA, "a replicate target", NA, NA)
    
    checkIdentical(as.character(obs[["experiment.sample"]]), list_dFrame.experiment.sample)
    checkIdentical(as.character(obs[["experiment.type"]]), list_dFrame.experiment.type)
    checkIdentical(as.character(obs[["replicate.experiment"]]), list_dFrame.replicate.experiment)
    checkIdentical(as.character(obs[["replicate.target"]]), list_dFrame.replicate.target)
}

test.column_list_numeric <- function () {
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    obs <- ENCODExplorerData:::clean_column("list_numeric", unitTest_df)
    exp <- c(NA, "32; 54", "43", "33; 42")
    checkIdentical(obs, exp)
}

test.column_list_logical <- function () {
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    obs <- ENCODExplorerData:::clean_column("list_logical", unitTest_df)
    exp <- c("FALSE", "TRUE", "FALSE; TRUE", NA)
    checkIdentical(obs, exp)
}

test.column_list_integer <- function() {
    load(file=system.file("extdata/unitTest_df.rda", package="ENCODExplorerData"))
    obs <- ENCODExplorerData:::clean_column("list_integer", unitTest_df)
    exp <- c("11; 22", NA, "33; 55", "70")
    checkIdentical(obs, exp)
}
