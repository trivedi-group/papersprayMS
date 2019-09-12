##DIMS direct data analysis. If anything doesn't work well, please open an issue on GitHub.##

## Import .csv as data.frame or convert them into separate data.frame. Easiest way is put all .csv in your working directory and use this:

list = list.files(pattern = "*.csv")
for (i in 1:length(list)) assign(list[i], read.csv(list[i]))

#BEFORE APPLYING NEXT STEP, MAKE SURE WORKSPACE HAS ONLY .CSV DATA FRAMES THAT YOU JUST IMPORTED. OTHERWISE YOU WILL CORRUPT THE DATA.

list.df <- lapply(ls(), function(x) if (class(get(x)) == "data.frame") get(x))
list.df = list.df[lapply(list.df, length)>0]


# from .csv to data frame, required for next step
for (i in seq(list.df))
  assign(paste0("df", i), list.df[[i]])


## Function to find and round numeric columns 
round_df <- function(df, digits) {
  nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
  
  df[,nums] <- round(df[,nums], digits = digits)
  
  (df)
}

## MANUAL step of rounding each data frame

'1074' = round_df(df1, digits=3)
'931' = round_df(df2, digits=3)
'933' = round_df(df3, digits=3)
'934' = round_df(df4, digits=3)
'936' = round_df(df5, digits=3)
'937' = round_df(df6, digits=3)
'982' = round_df(df7, digits=3)
'983' = round_df(df8, digits=3)
'987' = round_df(df9, digits=3)
'988' = round_df(df10, digits=3)


#Round so that we can group! 
`1074`$time = round(`1074`$time, 2)
`931`$time = round(`931`$time, 2)
`933`$time = round(`933`$time, 2)
`934`$time = round(`934`$time, 2)
`936`$time = round(`936`$time, 2)
`937`$time = round(`937`$time, 2)
`982`$time = round(`982`$time, 2)
`983`$time = round(`983`$time, 2)
`987`$time = round(`987`$time, 2)
`988`$time = round(`988`$time, 2)




## AT THIS STAGE - REMOVE ALL OTHER FILES MANUALLY FROM THE WORKSPACE BEFORE PROCEEDING FURTHER ###
## JUST KEEP THE NEW DATA FRAMES WE JUST GENERATED IN THE STEP ABOVE ##
## TRUST ME ##

list.df <- lapply(ls(), function(x) if (class(get(x)) == "data.frame") get(x))
list.df = list.df[lapply(list.df, length)>0]

## Join these into a single data.frame by mz values. If new mz values are present in some samples, preserve them. If same mz values are present join them.

library(plyr)
d1 = join_all(list.df, by='time', type = "left", match="all")

write.csv(d1, file="217_C.csv")

### THE BELOW CODE IS ONLY NEEDED IF PAPER SPRAY DATA IS ALL OVER THE PLACE AND SCAN TIMES ARE NOT IN SYNC ACROSS SAMPLES ####

#### DO NOT RUN THE CODE BELOW AS IT WILL RESULT IN POOR DATA QUALITY UNLESS YOU HAD ISSUES WITH SCAN TIMES ######



## We need to do some manual editing to this. The columns don't have names. These names will be generally in the order of your .csv files.
## Recommend you double check this and if it is, then run the code below to name each column heading. 
library(tidyverse)
library(dplyr)

d1new = as_tibble(d1, .name_repair = ~c("time", "X1014", "X1060", "1074", "901", "931", "933", "934", "936", "937", "982", "983",  "987", "988", "989"))
dataframe = tbl_df(d1new)

#Round so that we can group! 
dataframe$time = round(dataframe$time, 1)

#Combine!
no.na = dataframe %>% replace(.,is.na(.),"0.1")
View(no.na)

grp = no.na %>% group_by(time)
View(grp)

grp$time = as.factor(grp$time)

mean = grp %>% group_by(time) %>% summarise_all(funs(mean))
View(mean)

summed = no.na %>% group_by(time) %>% summarise_each(funs(sum))

output = write.csv(summed, file = "217_Control_new.csv")





