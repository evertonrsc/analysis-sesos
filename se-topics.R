install.packages(c("ggplot2", "RColorBrewer"))

library(ggplot2)
library(RColorBrewer)

# Dataset
topics <- c("Software system structures", "Software functional properties", "Extra-functional properties", "System description languages", "Development frameworks and environments", "Designing software", "Software verification and validation", "Software post-development issues")
numpapers <- c(16, 2, 16, 8, 5, 31, 12, 1)
data <- data.frame(topics, numpapers)

# Bar chart
barchart <- ggplot(data, aes(x=topics, y=numpapers)) + geom_bar(stat="identity", fill="dodgerblue3", width=0.7) + coord_flip() + geom_text(aes(label=numpapers), color="white", vjust=0.45, size=3.0, hjust=1.25) + labs(x="Software Engineering topics", y="Number of papers") + theme_classic() + theme(axis.title.x=element_text(vjust=-2.0, size=12.0), axis.text.x=element_text(size=10.0), axis.title.y=element_text(vjust=2.0, size=12.0), axis.text.y=element_text(size=10.0), legend.position="none", aspect.ratio=0.8/1) + ylim(0, max(data$numpapers))
barchart

# Save to file
ggsave("plots/se-topics.png", plot=barchart, device="png", dpi="print")