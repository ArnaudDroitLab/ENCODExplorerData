ENCODExplorerData: A compilation of ENCODE metadata
========================================================

<!-- badges: start -->
  [![Travis build status](https://travis-ci.org/ArnaudDroitLab/ENCODExplorerData.svg?branch=master)](https://travis-ci.org/ArnaudDroitLab/ENCODExplorerData)
  [![codecov](https://codecov.io/gh/ArnaudDroitLab/metagene2/branch/master/graph/badge.svg)](https://codecov.io/gh/ArnaudDroitLab/metagene2)
  [![Bioconductor Time](http://bioconductor.org/shields/years-in-bioc/ENCODExplorerData.svg)](http://bioconductor.org/packages/release/bioc/html/ENCODExplorerData.html "Bioconductor status")
<!-- badges: end -->

## Introduction ##

This package has been designed to facilitate data access by compiling the 
metadata associated with ENCODE files and making it available in the format
of a data table. While this data can be accessed as-is, we recommend using the
[ENCODExplorer](http://www.bioconductor.org/packages/release/bioc/html/ENCODExplorer.html) 
companion package, which contains utility functions
for using the online ENCODE search function, downloading selected files,
and retrieving control-treatment experimental designs from ENCODE.

## Installation ##

ENCODExplorerData is an official [Bioconductor](http://bioconductor.org/)
package. You can install it using the BiocManager package:

```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("ENCODExplorerData")
```

You can also obtain the current release from the 
[BioConductor website](http://www.bioconductor.org/packages/release/bioc/html/ENCODExplorerData.html).

## Regenerating or updating ENCODE metadata ##

To generate up-to-date version of the data tables exported by this package,
simply run the `inst/scripts/make-data.R` script. These will create files
named `encode_df_lite.rda` and `encode_df_full.rda` in the current directory.

## Authors ##

[Charles Joly Beauparlant](http://ca.linkedin.com/pub/charles-joly-beauparlant/89/491/3b3 "Charles Joly Beauparlant"), Eric Fournier and [Arnaud Droit](http://ca.linkedin.com/in/drarnaud "Arnaud Droit").

See [Arnaud Droit Lab](http://bioinformatique.ulaval.ca/home/ "Arnaud Droit Lab") website.

## Maintainer ##

[Eric Fournier](mailto:fournier.eric.2@crchudequebec.ulaval.ca "Eric Fournier")

## License ##

This package and the underlying ENCODExplorer code are distributed under the Artistic license 2.0. You are free to use and redistribute this software. 

For more information on Artistic 2.0 License see [http://opensource.org/licenses/Artistic-2.0](http://opensource.org/licenses/Artistic-2.0)

## Bugs/Feature requests ##

If you have any bugs or feature requests, [let us know](https://github.com/ArnaudDroitLab/ENCODExplorerData/issues). Thanks!
