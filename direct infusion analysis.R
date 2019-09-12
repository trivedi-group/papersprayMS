## ----loading, echo=TRUE, warning=FALSE, message=FALSE----------------------
# loading the packages
library(proFIA)

## ----paths-----------------------------------------------------------------
# finding the directory of the raw files
path <- dir(system.file("mzXML"), full.names=TRUE, recursive=TRUE)
list.files(path)

# performing the first step of the workflow
dataSet <- proFIAset("path/to/your/raw/data", ppm=20, parallel=FALSE)

## ----plot_injection--------------------------------------------------------
# plotting the injection peak
plotSamplePeaks(dataSet)

## ----group,message=FALSE---------------------------------------------------
group.data <- group.FIA(dataSet, ppmGroup=5, fracGroup=0.4)

## ----plotEICs--------------------------------------------------------------
#plotting the EICs of the parameters.
plotFlowgrams(group.data)

## ----datamatrix------------------------------------------------------------
# building the data matrix
datamatrix <- makeDataMatrix(group.data, maxo=FALSE)

## ----impute_fia, warning=FALSE, eval=FALSE---------------------------------
#  # k is supposed to be 3 at minimum, however here we have only 2 sample by class, the results of the imputation are therefore irrelevant.
#  k <- 3
#
#  #Missing values  imputation using kNN for truncated distribution by default.
#  plasSet <- impute.FIA(plasSet,k=k)
#
#  #Reinitializing the data matrix.
#  plasSet <- makeDataMatrix(plasSet)
#
#  #Imputation using random forest.
#  plasSet <- impute.FIA(plasSet,method="randomForest")
#
#  #As the dataset is ill-suited for missing value imputation we rebuild the data matrix.
#  plasSet <- makeDataMatrix(plasSet)

## ----plot,message=FALSE----------------------------------------------------
plot(plasSet)

## ----analyzeAcquisitionFIA, eval=FALSE-------------------------------------
#  #selecting the parameters
#  ppm <- 2
#  ppmgroup <- 1
#  fracGroup <- 0.2
#  k <- 3
#
#  # running the whole workflow in a single step
plasSet <- analyzeAcquisitionFIA(path, ppm=ppm, ppmGroup=ppmgroup, k=k,fracGroup = fracGroup,parallel=FALSE)
#
#  # Running the wholoe workflow in a single step, using parallelism
#  # with the BiocParallel package
DataSet <- analyzeAcquisitionFIA("path/to/your/raw/data", ppm=20, ppmGroup=5, k=5,fracGroup = 0.2, parallel=FALSE)
#

## ----export----------------------------------------------------------------
#Expression Set.
eset <- exportExpressionSet(plasSet)
eset

#Peak Table.
pt <- exportPeakTable(datamatrix)

#3 Tables:
dm <- exportDataMatrix(plasSet)
vm <- exportVariableMetadata(plasSet)

## ----multivariate----------------------------------------------------------
library(ropls)

data("plasSamples")
vconcentration <- plasSamples[,"concentration_ng_ml"]
#vconcentration=(c(100,100,1000,1000,10000,10000)*10^-10)
peakTable <- exportPeakTable(plasSet,mval="zero")

###Cutting the useless column
dataMatrix <- peakTable[,1:nrow(phenoClasses(plasSet))]

## ----plot_summary_opls, echo=FALSE-----------------------------------------
plasSet.opls <- opls(t(dataMatrix),log10(vconcentration),predI = 1,log10L = TRUE, orthoI = NA, devNewL = FALSE,crossvalI=5)

## ----plot_summary_opls_h, eval=FALSE---------------------------------------
#  plasSet.opls <- opls(t(peakTable),scale(log10(vconcentration)),predI = 1,log10L = TRUE, orthoI = NA)

## ----matrix_effect_plot----------------------------------------------------
matEfInd <- peakTable$corSampPeakMean
nnaVl <- !is.na(matEfInd)
matEfInd <- matEfInd[nnaVl]
ordVi <- order(matEfInd)
matEfInd <- matEfInd[ordVi]
vipVn <- getVipVn(plasSet.opls)[nnaVl]
orthoVipVn <- getVipVn(plasSet.opls, orthoL = TRUE)[nnaVl]
colVc <- rev(rainbow(sum(nnaVl), end = 4/6))
plot(vipVn[ordVi], orthoVipVn[ordVi], pch = 16, col = colVc,
     xlab = "VIP", ylab = "VIP_ortho", main = "VIP_ortho vs VIP.",lwd=3)

##Adding the point corresponding to samples.
points(getVipVn(plasSet.opls)[lMatch],getVipVn(plasSet.opls, orthoL = TRUE)[lMatch], cex=1.2,pch=1,col="black",lwd=2)
legend("topright", legend = c(round(rev(range(matEfInd)), 2),"Spiked molecules."), pch=c(16,16,1),col = c(rev(colVc[c(1, length(colVc))]),1))

## ----plotRaw_exemple_1, message = FALSE,warning=FALSE, results='hide'------
##Loading the plasFIA dataset
library(plasFIA)
library(proFIA)

data(plasSet)

###Selection of the first sample file
filepath <- phenoClasses(plasSet)[1,1]
filepath

###Loading the raw data
xraw <- xcmsRaw(filepath)

#proFIAset relies on the internal findBandsFIA function to detect m/z bands. The influence of ppm and dmz values can be visualized as follows:
band_list <- findBandsFIA(xraw, ppm = 15, dmz = 0.001)
mzlim <- c(233.067,233.082)
plotRaw(plasSet,sample=2,ylim=mzlim,type="r",legend=FALSE)
abline(h=band_list[,c("mzmin","mzmax")],lwd=0.5,lty=2,col="purple")

## ----plotRaw_exemple_2, message = FALSE,warning=FALSE, results='hide'------
band_list <- findBandsFIA(xraw, ppm = 2, dmz = 0.0005)
plotRaw(plasSet,sample=2,ylim=mzlim,type="r",legend=FALSE)
abline(h=band_list[,c("mzmin","mzmax")],lwd=0.5,lty=2,col="purple")

## ----group_good_value, message=FALSE, results="hide", eval=FALSE-----------
#  plasSet <- group.FIA(plasSet,ppmGroup=5,dmzGroup=0.001,fracGroup=3/18,sleep=0.001)

## ----group_wrong_value, message=FALSE, results="hide",eval=FALSE-----------
#  plasSet <- group.FIA(plasSet,ppmGroup=1,dmz=0.001,fracGroup=3/18,sleep=0.001)

## ----missing_values_1------------------------------------------------------
data(plasSet)

###You can reset the data matrix this way
plasSet <- makeDataMatrix(plasSet)

###Before imputation.
plot(plasSet)

## ----missing_values_2------------------------------------------------------
plasSet <- impute.randomForest(plasSet)

###After imputation.
plot(plasSet)

## ----cheat_sheet-----------------------------------------------------------
system.file(package="proFIA")

## ----sessionInfo, echo=FALSE-----------------------------------------------
sessionInfo()
