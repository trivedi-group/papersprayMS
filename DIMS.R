##Load required packages

library(proFIA)

## Running the workflow in a single step, with/without parallelism with the BiocParallel package

DataSet <- analyzeAcquisitionFIA("path/to/your/raw/data", 
                                 ppm=20, 
                                 dmz=0.001, 
                                 dmzGroup= 0.01, 
                                 ppmGroup=5, k=5,
                                 fracGroup = 0.2, 
                                 noiseEstimation = F, 
                                 SNT = 2,
                                 imputation = "KNN_TN",
                                 k = 0.3,
                                 parallel=F)

## Creating datamatrix ready for export
DataSet <- makeDataMatrix(DataSet)

## CreatinExpression Set
ExpSet <- exportExpressionSet(DataSet)

## Peak Table.
PkTbl <- exportPeakTable(datamatrix)

## Tables:
DatMat <- exportDataMatrix(DataSet)
VarMat <- exportVariableMetadata(DataSet)

## Write into a CSV for taking it out of R
result = write.csv(DatMat, "result.csv")

