install.packages(c("ggplot2", "RColorBrewer", "plyr"))

library(ggplot2)
library(RColorBrewer)
library(plyr)

# Dataset
years <- seq(2013, 2023)
editions <- rep(2013:2023, each=2)
numpapers <- c(10, 9, 
               11, 10, 
               8, 6, 
               6, 5, 
               15, 5, 
               5, 5, 
               10, 7, 
               8, 3, 
               5, 2, 
               6, 3, 
               10, 2)
acceptance <- rep(c("Accepted papers" , "Papers on SoS") , length(years))
data <- data.frame(years, acceptance, numpapers)

# Bar chart
barchart <- ggplot(data, aes(fill=acceptance, y=numpapers, x=editions)) + labs(x="SESoS Editions (years)", y="Number of papers") + geom_bar(stat="identity", position="dodge") + geom_text(aes(label=numpapers), vjust=-0.5, size=3.0, position=position_dodge(width=0.9)) + scale_x_continuous(labels=years, breaks=years) + theme_classic() + theme(legend.position="bottom", legend.title=element_blank(), axis.title.x=element_text(vjust=-2.5), axis.title.y=element_text(vjust=2.0), axis.text.x=element_text(size=10), axis.text.y=element_text(size=10)) + scale_fill_brewer(palette="Paired")
barchart

# Save to file
ggsave("plots/numpapers.png", plot=barchart, device="png", dpi="print")
