setwd(".")

install.packages(c("ggplot2", "RColorBrewer"))

library(ggplot2)
library(RColorBrewer)

# Dataset
years <- seq(2013, 2024)
editions <- rep(2013:2024, each=2)
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
               10, 2,
               10, 7)
acceptance <- rep(c("Accepted papers" , "Papers on SoS") , length(years))
data <- data.frame(editions, acceptance, numpapers)

average_papers <- mean(data$numpapers[acceptance=="Papers on SoS"])
average_papers

# Bar chart
barchart <- ggplot(data, aes(fill=acceptance, y=numpapers, x=editions)) + labs(x="SESoS Editions (years)", y="Number of papers") + geom_bar(stat="identity", position="dodge") + geom_text(aes(label=numpapers), hjust=0.75, vjust=-0.5, size=3.5, position=position_dodge(width=0.7)) + scale_x_continuous(labels=years, breaks=years) + theme_classic() + theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=10), axis.title.x=element_text(vjust=-2.5), axis.title.y=element_text(vjust=2.0), axis.text.x=element_text(size=12), axis.text.y=element_text(size=12)) + scale_fill_brewer(palette="Paired")
barchart

# Save to file
ggsave("plots/numpapers.png", plot=barchart, device="png", dpi="print")
