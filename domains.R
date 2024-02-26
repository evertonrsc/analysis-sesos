install.packages(c("ggplot2", "ggpubr", "ggthemes", "scales"))

library(ggplot2)
library(ggpubr)
library(ggthemes) # https://github.com/EmilHvitfeldt/r-color-palettes
library(scales)

domains <- c("Non-specific", "Smart grids", "Internet of Things", "Cyber-physical systems", "Retail", "Education", "Finance", "Digital twins")
numpapers <- c(47, 2, 3, 1, 1, 1, 1, 1)
data <- data.frame(domains, numpapers)

piechart <- ggpie(data, "numpapers", label=percent(data$numpapers/sum(numpapers), accuracy=.1), fill="domains") + theme(legend.position="right", legend.box.spacing=unit(12, "pt"), legend.title=element_text(size=10, face="bold"), legend.text=element_text(size=10), axis.text.x=element_text(size=8.5)) + guides(fill=guide_legend(title="Application domains or contexts")) + scale_fill_tableau(palette = "Classic Cyclic")
piechart

ggarrange(piechart) %>% ggexport(filename="plots/domains.png")

