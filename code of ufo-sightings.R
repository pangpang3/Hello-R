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

get.location <- function(l){
	spilt.location <-tryCatch(strsplit(l,",")[[1]],error=function(e) return(c(NA,NA)))
	clean.loaction <-gsub("^ ","",spilt.location)
	if(length(clean.location) > 2){
		return c(NA,NA)
	}
	else{
		return(clean.location)
	}
}

city.state <- lapply(ufo$Location,get.location) #lapply list-apply
location.matrix <- do.call(rbind,city.state) # similary with apply  do.call apply for list
ufo <- transform(ufo,USCity=location.marix[,1],USState=tolower(location.marix[,2]),stringAsFactors =FALSE)
us.states <- c("ak","") # need to complete this part
ufo$USState <- us.states[match(ufo$USState,us.states)]
ufo$USCity[is.na(ufo$USState)] <-NA
ufo.us <-subset(ufo, !is.na(USState))

quick.hist <- ggplot(ufo.us,aes(x=DateOccurred)) +geom_histogram()+scale_x_date(major="50 years")
ggsave(plot=quick.hist,filename="../images/quick_hist.png",height=6, width=8)
ufo.us <- subset(ufo.us, DateOccurred >= as.Date("1990-01-01"))
nrow(ufo.us)

ufo.us$YearMonth <- strftime(ufo.us.DateOccurred, format="%Y-%m")
sightings.counts <- ddply(ufo.us,.(USState,YearMonth),nrow)
head(sightings.counts)
