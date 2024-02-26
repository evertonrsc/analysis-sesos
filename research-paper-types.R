install.packages("ggplot2", "ggthemes")

library(ggplot2)
library(ggthemes)

# Dataset
research_types <- c("Validation", "Evaluation", "Solution proposal", "Philosophical", "Opinion", "Experience", "Secondary study")
paper_types <- rep(c("Regular paper", "Short/position paper"), each=7)
numpapers <- c(9, 5, 7, 4, 0, 3, 9,
               1, 1, 6, 11, 1, 0, 0)
grid <- data.frame(research_types, paper_types, numpapers)

# Barchart
barchart <- ggplot(grid[which(numpapers>0),], aes(x=factor(research_types), y=numpapers, fill=paper_types, colour=paper_types)) + labs(x="Research types", y="Number of papers") + geom_bar(stat="identity", width=0.5, color="white") + geom_text(aes(label=numpapers), size=3, position=position_stack(vjust=0.5), colour="gray25") + coord_flip() + theme_classic() + theme(legend.position="bottom", legend.justification="center", legend.box.spacing=unit(12, "pt"), legend.title=element_text(size=10, face="bold"), legend.text=element_text(size=10), axis.text.x=element_text(vjust=-2), axis.title.x=element_text(vjust=-2.0), axis.title.y=element_text(vjust=3.0), aspect.ratio=0.4/1) + guides(fill=guide_legend(title="Paper categories in SESoS")) + scale_fill_few(palette="Light")
barchart

# Save to file
ggsave("research-paper-types.png", plot=barchart, device="png", dpi="print")