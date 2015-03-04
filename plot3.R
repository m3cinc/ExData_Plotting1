## Plot#3  Energy sub metering vs time over 2 day period
##
## This R code to generate plot3.PNG file as illustrated and described in assignment
##
## input: zipfile https url, stored in url variable
## output: hpc data.frame with 2880 rows or 8 tidy data variables
##         a copy of the hpc data.frame saved as hpc_dataset file in the ./data subdirectory
##         plot3.png plot file and display in the Plot console
##
## note: typical RStudio console output are commented along with #>
##       RStudio Version 0.98.1091 - © 2009-2014 RStudio, Inc.
##       R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
##       Copyright (C) 2014 The R Foundation for Statistical Computing
##       Platform: x86_64-w64-mingw32/x64 (64-bit)
##
##
## Exdata-012 assignment 1 - Part1 from ReadData.R
##
## This R code fetches a specific zip formatted dataset specified in an https ssl url
## reads and unzips the data (~20MB), subsets and formats appropriately for
## plots in a data.frame and saves the dataset
##
## input: zipfile https url, stored in url variable
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
## output: hpc data.frame with 2880 rows or 8 tidy data variables
##         extracted between 2007-02-01 and 2007-02-02 every 10 seconds
##         a copy of the hpc data.frame saved as hpc_dataset file in the ./data subdirectory
##         plot3.png 480x480 pix with white bg and black,red,blue color lineplots representing
##         Energy sub metering (overlay) for sub metering 1:3) vs Time with legend in right
##         upper corner
myPNGfile<-"plot3.png"
##
## note: typical RStudio console output are commented along with #>
##       RStudio Version 0.98.1091 - © 2009-2014 RStudio, Inc.
##       R version 3.1.2 (2014-10-31) -- "Pumpkin Helmet"
##       Copyright (C) 2014 The R Foundation for Statistical Computing
##       Platform: x86_64-w64-mingw32/x64 (64-bit)
##
## Start with a fresh subdirectory and set it as working directory
##
setwd("R:/ExData_Plotting1")
##
## Create a data subdirectory below working directory to import the datafile
if (!file.exists("data")) {
        dir.create("data")
}
##
## install RCurl package needed for zip retrieval with https ssl
install.packages("RCurl") 
#> Warning in install.packages :
#>         downloaded length 227 != reported length 227
#> trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.1/RCurl_1.95-4.5.zip'
#> Content type 'application/zip' length 2703917 bytes (2.6 Mb)
#> opened URL
#> downloaded 2.6 Mb
#> 
#> package 'RCurl' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  ...\downloaded_packages
##
library(RCurl)
#> Loading required package: bitops
##
## populate the url to download the zip file under reproducible conditions
## This automatic step is required to preserve reproducible data stream integrity
##
download.file(url, dest="./data/dataset.zip", mode="wb") 
##
#> trying URL 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
#> Content type 'application/zip' length 20640916 bytes (19.7 Mb)
#> opened URL
#> downloaded 19.7 Mb
##
##  unzip to the data subdirectory freshly created
unzip ("./data/dataset.zip", exdir = "./data") # will create the txt file
unlink("./data/dataset.zip") # Cleanup
##
## we now have the datafile and verify its characteristics for trail documentation
##
print(list.files("./data"))    # to confirm file is copied to the /data directory
#> [1] "exdata-data-household_power_consumption.zip" "household_power_consumption.txt"            
#> [3] "hpc_dataset"        
dateDownloaded_csv<-date()  # to confirm file datestamp and enable back tracking
print(dateDownloaded_csv)
#> [1] "Wed Mar 04 13:42:31 2015"
##
## now we extract the dataset needed for analysis into a data.frame: all parameters are essential
##
hpc<-read.table("./data/household_power_consumption.txt",
                sep=";",
                dec=".",
                colClasses=c(rep("character",2),rep("numeric",7)),
                header=TRUE,
                na.strings="?",
                stringsAsFactors=FALSE)
##
## perform a sanity check on the data read, by invoking at str()ucture and head()
##
str(hpc)
#> 'data.frame':        2075259 obs. of  9 variables:
#> $ Date                 : chr  "16/12/2006" "16/12/2006" "16/12/2006" "16/12/2006" ...
#> $ Time                 : chr  "17:24:00" "17:25:00" "17:26:00" "17:27:00" ...
#> $ Global_active_power  : num  4.22 5.36 5.37 5.39 3.67 ...
#> $ Global_reactive_power: num  0.418 0.436 0.498 0.502 0.528 0.522 0.52 0.52 0.51 0.51 ...
#> $ Voltage              : num  235 234 233 234 236 ...
#> $ Global_intensity     : num  18.4 23 23 23 15.8 15 15.8 15.8 15.8 15.8 ...
#> $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
#> $ Sub_metering_2       : num  1 1 2 1 1 2 1 1 1 2 ...
#> $ Sub_metering_3       : num  17 16 17 17 17 17 17 17 17 16 ...
##
## The dataset has effectively 2,075,259 observations(rows) and 9 variables (columns)
##
head(hpc,5)
#> Date     Time Global_active_power Global_reactive_power Voltage Global_intensity
#> 1 16/12/2006 17:24:00               4.216                 0.418  234.84             18.4
#> 2 16/12/2006 17:25:00               5.360                 0.436  233.63             23.0
#> 3 16/12/2006 17:26:00               5.374                 0.498  233.29             23.0
#> 4 16/12/2006 17:27:00               5.388                 0.502  233.74             23.0
#> 5 16/12/2006 17:28:00               3.666                 0.528  235.68             15.8
#> Sub_metering_1 Sub_metering_2 Sub_metering_3
#> 1              0              1             17
#> 2              0              1             16
#> 3              0              2             17
#> 4              0              1             17
#> 5              0              1             17
##
## Start with removing missing values
hpc<-hpc[complete.cases(hpc),]
## verify we reduced the set to 2,049,280 obs. of 9 variables
str(hpc)
#> 'data.frame':        2049280 obs. of  9 variables:
#> $ Date                 : chr  "16/12/2006" "16/12/2006" "16/12/2006" "16/12/2006" ...
#> $ Time                 : chr  "17:24:00" "17:25:00" "17:26:00" "17:27:00" ...
#> $ Global_active_power  : num  4.22 5.36 5.37 5.39 3.67 ...
#> $ Global_reactive_power: num  0.418 0.436 0.498 0.502 0.528 0.522 0.52 0.52 0.51 0.51 ...
#> $ Voltage              : num  235 234 233 234 236 ...
#> $ Global_intensity     : num  18.4 23 23 23 15.8 15 15.8 15.8 15.8 15.8 ...
#> $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
#> $ Sub_metering_2       : num  1 1 2 1 1 2 1 1 1 2 ...
#> $ Sub_metering_3       : num  17 16 17 17 17 17 17 17 17 16 ...
##
## now recast the Date vector from chr to Date format from %d/%m/%Y
##
hpc$Date<-as.Date(hpc$Date,"%d/%m/%Y")
##
## perform subsetting to include either 2007-02-01 or 2007-02-02 (in ISO8601 representation)
##
hpc<-hpc[hpc$Date==as.Date("2007-02-01","%Y-%m-%d")
         |hpc$Date==as.Date("2007-02-02","%Y-%m-%d"),]
##
## now recast the Time vector from chr to POSIXlt format "%Y-%m-%d %H:%M:%S"
## this will produce some redondancy in the data as Time also includes the Date
## we will address next to make our data tidy...
##
hpc$Time<-strptime(paste(hpc$Date,hpc$Time),"%Y-%m-%d %H:%M:%S")
##
## we verify our data subset: it should contain (48hrs*60min/hrs*1data sample/min)= 2880 rows of data
## the dataset should contain 2880 rows of 9 variables of data (48hrs*60min/hrs*1data sample/min)
str(hpc)
#> 'data.frame':        2880 obs. of  9 variables:
#> $ Date                 : Date, format: "2007-02-01" "2007-02-01" "2007-02-01" ...
#> $ Time                 : POSIXlt, format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" "2007-02-01 00:02:00" ...
#> $ Global_active_power  : num  0.326 0.326 0.324 0.324 0.322 0.32 0.32 0.32 0.32 0.236 ...
#> $ Global_reactive_power: num  0.128 0.13 0.132 0.134 0.13 0.126 0.126 0.126 0.128 0 ...
#> $ Voltage              : num  243 243 244 244 243 ...
#> $ Global_intensity     : num  1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1 ...
#> $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
#> $ Sub_metering_2       : num  0 0 0 0 0 0 0 0 0 0 ...
#> $ Sub_metering_3       : num  0 0 0 0 0 0 0 0 0 0 ...
##
## Now eliminate the Date vector as its content is captured in the Time vector
## This will make our dataset tidy: one set of property per variable
##
hpc<-hpc[-1]
## last sanitation check on this dataset we'll use for plots
##
str(hpc)
#> 'data.frame':        2880 obs. of  8 variables:
#> $ Time                 : POSIXlt, format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" "2007-02-01 00:02:00" ...
#> $ Global_active_power  : num  0.326 0.326 0.324 0.324 0.322 0.32 0.32 0.32 0.32 0.236 ...
#> $ Global_reactive_power: num  0.128 0.13 0.132 0.134 0.13 0.126 0.126 0.126 0.128 0 ...
#> $ Voltage              : num  243 243 244 244 243 ...
#> $ Global_intensity     : num  1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1 ...
#> $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
#> $ Sub_metering_2       : num  0 0 0 0 0 0 0 0 0 0 ...
#> $ Sub_metering_3       : num  0 0 0 0 0 0 0 0 0 0 ...
##
## we can save an image, just in case...
##
save(list="hpc",file="./data/hpc_dataset")
##
## and record some file information data for timestamping and data trail markers
##
print(file.info(file="./data/hpc_dataset"))
#>                     size isdir mode               mtime               ctime               atime exe
#> ./data/hpc_dataset 27413 FALSE  666 2015-03-04 13:43:07 2015-03-04 10:30:41 2015-03-04 10:30:41  no
##
## This concludes the ReadData portion: hpc data subset is ready for plots
##
## check we have the dataset loaded with same size and reload if possible
##
if(!(nrow(hpc)==2880 & length(hpc)==8)){
        if (file.exists("./data/hpc_dataset")==T) {
                load("./data/hpc_dataset")
        } else {
                stop("Data is needed before plots...")
        } 
}
## Save device parameters before plots so we can restore device on exit
##
oldpar<-par()
##
## set for single plot, standard margins and outer margins
par(mfrow=c(1,1),mar=c(5,4,4,2)+0.1,oma=c(0,0,0,0))
with(hpc,{
        plot(Time,Sub_metering_1,
             col="black", 
             xlab="",
             ylab="Energy sub metering",type="l");
        lines(Time,Sub_metering_2,
              col="red",
              type="l");
        lines(Time,Sub_metering_3,
              col="blue",
              type="l");
        legend(x=hpc$Time[1700],y=30,
               lty=1,
               x.intersp=1,
               y.intersp=.5,
               xjust=0,
               yjust=0,
               bty="n",
               seg.len=2,
               xpd=1.0,
               col=c("black","red","blue"),
               legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
               )
         }
)
##
## copy output in PNG format as specified
##
dev.copy(png,file=myPNGfile,
         width=480,
         height=480,
         units="px",
         pointsize=14,
         bg="white",
         res=NA)
##
## Close the PNG device before restoring
##
dev.off() 
##
## reset the device parameters we had tweaked to their initial state
##
par(mfrow=oldpar$mfrow,mar=oldpar$mar,oma=oldpar$oma)
##
## verify PNG file exists and indicate its file.info()
print(file.exists(myPNGfile))
#> [1] TRUE
print(file.info(myPNGfile))
#>           size isdir mode               mtime               ctime               atime exe
#> plot3.png 4339 FALSE  666 2015-03-04 16:03:31 2015-03-03 21:31:01 2015-03-03 21:31:01  no
##
## This concludes plot#3