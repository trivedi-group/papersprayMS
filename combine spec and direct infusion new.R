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

spec_list <- split(spec, fromFile(spec))

newexp <- lapply(spec_list, function(z) {
  res <- combineSpectra(z, 
                        mzFun = base::mean, 
                        intensityFun = base::mean)
  as(res, "MSnExp")
})

for (i in seq_along(newexp)) {
  writeMSData(newexp[[i]], file = paste0(i, ".mzML"))
}


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


### Set new path for new files ###

files = list.files("path/to/your/raw/data/Singles", recursive = TRUE, full.names = TRUE)

### Let's xcms this thing! ###

xset = xcmsSet(files = files, )



### Find peaks ###
peaks = findChromPeaks(newdata,
                       param = msw)

head(chromPeaks(peaks))

### Fill missing peaks ###
group.peaks = groupChromPeaks(peaks)
fill.peaks = fillChromPeaks(peaks)


### Annotate ###


