install.packages(c("ggplot2", "RColorBrewer"))

library(ggplot2)
library(RColorBrewer)

# Dataset
research_types <- c("Validation", "Evaluation", "Solution proposal", "Philosophical", "Opinion", "Experience", "Secondary study")
numpapers <- c(10, 6, 13, 15, 1, 3, 9)
data <- data.frame(research_types, numpapers)

# Bar chart
barchart <- ggplot(data, aes(x=research_types, y=numpapers)) + geom_bar(stat="identity", fill="lightskyblue1", width=0.7) + coord_flip() + geom_text(aes(label=numpapers), color="black", vjust=0.45, size=3.0, hjust=1.5) + labs(x="Research types", y="Number of papers") + theme_classic() + theme(axis.title.x=element_text(vjust=-2.0, size=12.0), axis.text.x=element_text(size=10.0), axis.title.y=element_text(vjust=2.0, size=12.0), axis.text.y=element_text(size=10.0), legend.position="none", aspect.ratio=0.4/1) + ylim(0, 15)
barchart

# Save to file
ggsave("plots/research-types.png", plot=barchart, device="png", dpi="print")