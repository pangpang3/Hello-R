library(ggplots2)  #同时加载了plyr 和reshape 包
ufo <- read.delim("data/ufo/ufo_awesome.tsv", sep='\t', stringAsFactors=FALSE,header=FALSE,na.strings="")  # all read.* funcitons will convert char into factor
names(ufo) <- c("DateOccurred","DateReported","Location","ShortDescription","Duration","LongDescription")
#ufo$DateOccirred <- as.Date(ufo$DateOccirred, formate="%Y%m%d")
#Error in strptime:input string is too long :malformed data
head(ufo[which(nchar(ufo$DateOccirred)!=8 |nchar(ufo$DateReported)!=8),1])
good.rows <-ifelse(nchar(ufo$DateOccirred)!=8 |nchar(ufo$DateReported)!=8,FALSE,TRUE)
length(which(!good.rows))
ufo <- ufo[good.rows]
ufo$DateOccirred <- as.Date(ufo$DateOccirred, formate="%Y%m%d")
ufo$DateReported <- as.Date(ufo$DateReported, formate="%Y%m%d")
