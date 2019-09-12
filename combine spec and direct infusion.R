### Direct infusion pipeline based on MSnBase and XCMS. For any issues, please open an issue on GitHub. ###

### Load required packages ###
library(xcms)
library(MassSpecWavelet)
#############################

### Read file ###

file.prof = list.files("path/to/your/raw/data", recursive = TRUE, full.names = TRUE)

## Read profiles ###

prof.files = readMSData(file.prof, 
                       pdata = NULL, 
                       msLevel. = 1,
                       verbose = isMSnbaseVerbose(), 
                       centroided. = NA, 
                       smoothed. = NA,
                       mode = "onDisk")

### Create spectra ###

spec= Spectra(spectra(prof.files))

### Combine spectra into one ###
res = combineSpectra(spec, 
                     mzFun = base::mean, 
                     intensityFun = base::mean)

### Create a new mzxml with single spectra ###

newexp = as(res, "MSnExp")
output = tempfile()
writeMSData(object = newexp, file = output, outformat="mzxml")
newdata = readMSData(output, mode="onDisk")

### Define parameters for pick picking ###
msw = MSWParam(scales = c(1,4,9,16,25),
               nearbyPeak = TRUE,
               winSize.noise = 100,
               SNR.method = "data.mean",
               snthresh = 2)

### Find peaks ###
peaks = findChromPeaks(newdata,
                       param = msw)

### Fill missing peaks ###




### Annotate ###


