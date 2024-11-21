install.packages(c("ggplot2", "ggpubr", "ggthemes", "scales"))

library(ggplot2)
library(ggpubr)
library(ggthemes) # https://github.com/EmilHvitfeldt/r-color-palettes
library(scales)

domains <- c("Non-specific", "Smart grids", "Internet of Things", "Cyber-physical systems", "Retail", "Education", "Finance", "Digital twins", "Manufacturing", "Healthcare")
numpapers <- c(51, 2, 3, 2, 1, 1, 1, 1, 1, 1)
data <- data.frame(domains, numpapers)

piechart <- ggpie(data, "numpapers", label=percent(data$numpapers/sum(numpapers), accuracy=.1), fill="domains") + 
  theme(legend.position="bottom", legend.box.spacing=unit(-20, "pt"), legend.title=element_text(size=10.5, face="bold"), legend.text=element_text(size=10.5), axis.text.x=element_text(size=10)) + 
  guides(fill=guide_legend(title="Application domains or contexts")) + 
  scale_fill_tableau(palette="Classic Cyclic", limits=domains)
piechart

ggsave("plots/domains.png", plot=piechart, device="png", dpi="print")

