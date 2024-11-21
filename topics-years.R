setwd(".")

install.packages("ggplot2")

library(ggplot2)

# Dataset
topics <- c("Analysis & Architecture", "Model-Based Engineering", "Construction & Evolution", "Experience", "General Issues", "Challenges & Directions")
years <- rep(2013:2024, each=6)
numpapers <- c(6,0,2,2,1,6, 
               4,5,1,0,4,2, 
               5,0,0,1,1,2, 
               0,2,2,0,2,1, 
               1,2,2,0,2,0, 
               1,0,2,0,3,1,  
               0,2,0,3,3,1,
               1,0,1,0,1,0, 
               0,0,1,0,1,0, 
               0,0,2,0,0,1, 
               0,0,0,2,0,2,
               3,1,3,1,0,0)
grid <- data.frame(years, topics, numpapers)
grid$radius <- sqrt(grid$numpapers / pi)

# Bubble chart
bubblechart <- ggplot(grid[which(grid$radius > 0),], aes(as.character(years), topics)) + labs(x="SESoS Editions (years)", y="Categories of topics of interest") + geom_point(aes(size=radius*7.5), shape=21, fill="white", color="#666666") + geom_text(aes(label=numpapers), size=3.5) + scale_size_identity() + theme(panel.background=element_blank(), panel.grid.major=element_line(linetype=2, color="#cccccc"), axis.ticks.length=unit(0, "pt"), axis.title.x=element_text(vjust=-6), axis.title.y=element_text(vjust=2.5), axis.text.x=element_text(size=12, vjust=-2.0), axis.text.y=element_text(size=12), aspect.ratio=0.4/1)
bubblechart

# Save to file
ggsave("plots/topics-years.png", plot=bubblechart, device="png", dpi="print")