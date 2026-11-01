# papersprayMS

R scripts for processing paper spray mass spectrometry (PS-MS) and other direct infusion mass spectrometry (DIMS) data, developed by the Trivedi Research Group at the University of Manchester. The scripts take raw or exported spectra, combine scans, align m/z values across samples and build a data matrix ready for chemometric analysis.

These are working research scripts rather than a packaged library. They were written for specific datasets and are best used as templates to adapt to your own data. Instructions for each step are given as comments inside the scripts.

## What is in the repository

### Feature detection with proFIA

* `DIMS.R` runs the full proFIA workflow in a single call (`analyzeAcquisitionFIA`) on a folder of raw files. It detects m/z bands, groups features across samples, imputes missing values by k nearest neighbours and writes the resulting data matrix to `result.csv`.
* `direct infusion analysis.R` is a step by step proFIA workflow adapted from the proFIA package vignette. It builds the proFIA set, groups features, plots flowgrams, constructs and exports the data matrix, and then fits an OPLS model with ropls. The later sections reproduce the vignette examples on the plasFIA dataset and show how the ppm and dmz parameters affect band detection and how missing values can be imputed.
* `direct infusion analysis` (no file extension) is an earlier copy of the same workflow that points to the example data shipped with proFIA rather than a local data folder.

### Combining scans with MSnbase and XCMS

* `combine spec and direct infusion.R` reads profile mode files with MSnbase, averages all scans into a single spectrum, writes this back out as mzXML and detects peaks with the MassSpecWavelet algorithm through XCMS.
* `combine spec and direct infusion new.R` extends this so that scans are averaged separately for each file, giving one combined mzML file per sample before peak picking, grouping and gap filling.

### Working with exported spectra (CSV)

* `spectra maths - dims.R` imports one CSV file of m/z and intensity per sample, joins them by m/z, rounds m/z to four decimal places and averages duplicate values. It can also aggregate the data to nominal mass.
* `dims mz scan cleanup.R` imports CSV files of intensity against scan time, rounds the scan times, joins the samples by time and sums or averages within each time window. The final section is only needed when scan times are not synchronised across samples, as the script itself warns.

### Spectral pre-processing with ChemoSpec

* `ChemoSpec.R` reads a CSV matrix of spectra into a ChemoSpec object, summarises and plots it, and applies baseline correction by modified polynomial fitting.

## Requirements

* R (version 4 or later recommended)
* Bioconductor packages: proFIA, xcms, MSnbase, MassSpecWavelet, ropls and plasFIA (example data only)
* CRAN packages: ChemoSpec, plyr, dplyr and tidyverse

The packages can be installed as follows.

```r
install.packages(c("BiocManager", "ChemoSpec", "plyr", "dplyr", "tidyverse"))
BiocManager::install(c("proFIA", "xcms", "MSnbase", "MassSpecWavelet", "ropls", "plasFIA"))
```

## Using the scripts

1. Convert vendor raw files to an open format (mzML, mzXML or netCDF) for the proFIA and XCMS scripts, or export spectra to CSV for the CSV scripts.
2. Open the script you need in R or RStudio.
3. Change the folder paths. Several scripts contain hard coded paths to local folders, for example in `setwd()`, `list.files()` and `analyzeAcquisitionFIA()`, and these must point to your own data.
4. Check the processing parameters, such as `ppm`, `dmz`, `ppmGroup` and `fracGroup` in proFIA, against your instrument resolution and study design before running.
5. Run the script section by section and inspect the plots and tables at each stage.

The CSV scripts load every data frame in the R workspace. Start from a clean workspace containing only the imported files, as the comments in those scripts explain. Some steps, such as renaming columns and rounding each sample, are written out by hand for a particular dataset and will need editing for yours.

## Status

The scripts are a work in progress. A tidied workflow and tutorial are planned. Please check outputs carefully before using them in published work.

## References

Delabrière A, Hohenester UM, Colsch B, Junot C, Fenaille F, Thévenot EA. proFIA: a data preprocessing workflow for flow injection analysis coupled to high resolution mass spectrometry. Bioinformatics. 2017, 33(23), 3767 to 3775.

Gatto L, Lilley KS. MSnbase, an R/Bioconductor package for isobaric tagged mass spectrometry data visualization, processing and quantitation. Bioinformatics. 2012, 28(2), 288 to 289.

Smith CA, Want EJ, O'Maille G, Abagyan R, Siuzdak G. XCMS: processing mass spectrometry data for metabolite profiling using nonlinear peak alignment, matching, and identification. Analytical Chemistry. 2006, 78(3), 779 to 787.

Thévenot EA, Roux A, Xu Y, Ezan E, Junot C. Analysis of the human adult urinary metabolome variations with age, body mass index, and gender by implementing a comprehensive workflow for univariate and OPLS statistical analyses. Journal of Proteome Research. 2015, 14(8), 3322 to 3335.

Wang H, Liu J, Cooks RG, Ouyang Z. Paper spray for direct analysis of complex mixtures using mass spectrometry. Angewandte Chemie International Edition. 2010, 49(5), 877 to 880.

## Licence

Released under the GNU General Public License v3.0. See `LICENSE` for the full text.
