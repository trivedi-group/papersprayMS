##Load necessary package
library(ChemoSpec)

##Set your working directory where the .csv files with data is
setwd("path/to/your/working/directory")

##create a spectra object
spec = matrix2SpectraObject(gr.crit=c("A","B"), 
                           gr.col=c("red","blue"), 
                           freq.unit="mz", 
                           int.unit="peak intensity", 
                           descrip = "Reproducibility Study", 
                           out.file="output", 
                           in.file="calibration.csv", 
                           sep=",")

##Summarize what you just created
sumSpectra(spec)

##Plot Spectra
loopThruSpectra(spec)

##Baseline correct Spectra
baselinespec = baselineSpectra(spec, int=F, retC=T, method="modpolyfit")


