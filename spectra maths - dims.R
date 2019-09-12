##DIMS direct data analysis. If anything doesn't work well, please open an issue on GitHub.##

## Import .csv as data.frame or convert them into separate data.frame. Easiest way is put all .csv in your working directory and use this:

list = list.files(pattern = "*.csv")
for (i in 1:length(list)) assign(list[i], read.csv(list[i]))

#BEFORE APPLYING NEXT STEP, MAKE SURE WORKSPACE HAS ONLY .CSV DATA FRAMES THAT YOU JUST IMPORTED. OTHERWISE YOU WILL CORRUPT THE DATA.

list.df <- lapply(ls(), function(x) if (class(get(x)) == "data.frame") get(x))
list.df = list.df[lapply(list.df, length)>0]

## Join these into a single data.frame by mz values. If new mz values are present in some samples, preserve them. If same mz values are present join them.

library(plyr)

d1 = join_all(list.df, by='mz')

#Need to have all data in form of a matrix. First column should be mz, followed by intensity values per sample in each column
#Assuming data frame is called d1. 
d1$mz = round(d1$mz, 4)
View(d1)

## We need to do some manual editing to this. The columns don't have names. These names will be generally in the order of your .csv files.
## Recommend you double check this and if it is, then run the code below to name each column heading. 
library(tidyverse)
library(dplyr)

d1new = as_tibble(d1, .name_repair = ~c("mz", 001:117))
dataframe = tbl_df(d1new)
summed = dataframe %>% group_by(mz) %>% summarise_all(funs(mean))
output = write.csv(summed, file = "paperspray_June3.csv")

##For more mass accuracy say upto X decimal points, you can sum mz and peak areas
summed$mz = round(summed$mz, digits=0)
df2 = aggregate(.~mz, summed, sum)
write.csv(df2, file="nominal.csv")
output2 = write.csv(df1, file="mz_diff_point2.csv")
