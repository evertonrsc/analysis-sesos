install.packages(c("ggplot2", "ggpubr", "ggthemes", "scales"))

library(ggplot2)
library(ggpubr)
library(ggthemes) # https://github.com/EmilHvitfeldt/r-color-palettes
library(scales)

sostypes <- c("Non-specified", "Directed", "Acknowledged", "Collaborative", "Virtual")
numpapers <- c(18, 10, 10, 1, 1)
data <- data.frame(sostypes, numpapers)

piechart <- ggpie(data, "numpapers", label=percent(data$numpapers/sum(numpapers), accuracy=.1), fill="sostypes") + 
  theme(legend.position="bottom", legend.justification="center", legend.box.spacing=unit(-12, "pt"), legend.title=element_text(size=10, face="bold"), legend.text=element_text(size=10), axis.text.x=element_text(size=11)) + 
  guides(fill=guide_legend(title="SoS types")) + 
  scale_fill_tableau(palette="Tableau 20", limits=sostypes)
piechart

ggsave("plots/sostypes.png", plot=piechart, device="png", dpi="print")
