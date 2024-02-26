install.packages("ggplot2")

install.packages("devtools")
library(devtools)
install_github("ellisp/ggflags")  # https://github.com/ellisp/ggflags

library(ggplot2)
library(ggflags)

# Dataset
# Each country is represented by an alpha-2 code (ISO 3166)
topics <- c("Analysis & Architecture", "Model-Based Engineering", "Construction & Evolution", "Experience", "General Issues", "Challenges & Directions")
countries <- rep(c("BR", "FR", "SE", "KR", "DE", "ES", "IT", "US", "AT", "GB", "NL", "TN", "AU"), each=6)
numpapers <- c(8, 3, 7, 2, 8, 9, 
               8, 5, 1, 0, 2, 3,
               2, 0, 2, 1, 1, 3,
               0, 2, 1, 0, 4, 0,
               0, 2, 1, 1, 3, 2,
               4, 0, 0, 2, 1, 2,
               0, 2, 0, 1, 2, 1,
               1, 0, 1, 0, 2, 1,
               1, 0, 1, 1, 0, 1,
               1, 0, 0, 0, 0, 1,
               1, 0, 0, 0, 0, 1,
               1, 1, 0, 0, 0, 0,
               1, 0, 0, 0, 0, 0)
grid <- data.frame(topics, countries, numpapers)
grid$radius <- sqrt(grid$numpapers / pi)

# Bubble chart
# geom_flag is used to plot country flags
bubblechart <- ggplot(grid[which(grid$radius > 0),], aes(countries, topics)) + geom_flag(y=0.35, aes(country=tolower(countries)), size=7) + labs(x="Countries", y="Categories of topics of interest") + geom_point(aes(size=radius*7.5), shape=21, fill="white", color="#666666") + geom_text(aes(label=numpapers), size=3.5) + scale_size_identity() + theme(panel.background=element_blank(), panel.grid.major=element_line(linetype=2, color="#cccccc"), axis.ticks.length=unit(0, "pt"), axis.title.x=element_text(vjust=-4), axis.title.y=element_text(vjust=2.5), axis.text.x=element_text(size=8, vjust=-1.0), aspect.ratio=0.45/1) + expand_limits(y=0.2)
bubblechart

# Save to file
ggsave("plots/topics-countries.png", plot=bubblechart, device="png", dpi="print")