install.packages("ggplot2")

library(ggplot2)

# Dataset
topics <- c("Analysis & Architecture", "Model-Based Engineering", "Construction & Evolution", "Experience", "General Issues", "Challenges & Directions")
numpapers <- c(18, 11, 13, 8, 18, 16)
data <- data.frame(topics, numpapers)

# Bar chart
barchart <- ggplot(data, aes(x=topics, y=numpapers)) + geom_bar(stat="identity", fill="skyblue4", width=0.7) + coord_flip() + geom_text(aes(label=numpapers), color="white", vjust=0.6, size=3.5, hjust=1.5) + labs(x="Categories of topics of interest", y="Number of papers") + theme_classic() + theme(axis.title.x=element_text(vjust=-2.0, size=12.0), axis.text.x=element_text(size=10.0), axis.title.y=element_text(vjust=2.0, size=12.0), axis.text.y=element_text(size=10.0), legend.position="none", aspect.ratio=0.6/1) + ylim(0, 20)
barchart

# Save to file
ggsave("plots/topics.png", plot=barchart, device="png", dpi="print")