install.packages("ggraph")
install.packages("igraph")
install.packages("RColorBrewer")

library(ggraph)
library(igraph)
library(RColorBrewer)

# Create hierarchy: root -> years (2013-2023) -> papers (Pn)
years <- data.frame(from="root", to=seq(2013,2023))
papers <- data.frame(from=c(
  rep(2013, times=9),
  rep(2014, times=10),
  rep(2015, times=6),
  rep(2016, times=5),
  rep(2017, times=5),
  rep(2018, times=5),
  rep(2019, times=7),
  rep(2020, times=3),
  rep(2021, times=2),
  rep(2022, times=3),
  rep(2023, times=2)
), to=c(
  paste("P", seq(1,9), sep=""),
  paste("P", seq(10,19), sep=""),
  paste("P", seq(20,25), sep=""),
  paste("P", seq(26,30), sep=""),
  paste("P", seq(31,35), sep=""),
  paste("P", seq(36,40), sep=""),
  paste("P", seq(41,47), sep=""),
  paste("P", seq(48,50), sep=""),
  paste("P", seq(51,52), sep=""),
  paste("P", seq(53,55), sep=""),
  paste("P", seq(56,57), sep="")
))
hierarchy <- rbind(years, papers)

# Create a dataframe with connection between leaves (individuals)
all_leaves <- paste("P", seq(1,57), sep="")
connect <- read.csv("crossref.csv", header=FALSE)
colnames(connect) <- c("from", "to")
connect$value <- runif(nrow(connect))

# Create a vertices dataframe
vertices <- data.frame(name=unique(c(as.character(hierarchy$from), as.character(hierarchy$to))))
vertices$group <- hierarchy$from[match(vertices$name, hierarchy$to)]

# Add information concerning the label we are going to add: 
# angle, horizontal adjustment, and potential flip
# Calculate the angle of the labels
vertices$id <- NA
match_ <- which(is.na(match(vertices$name, hierarchy$from)))
nleaves <- length(match_)
vertices$id[match_] <- seq(1:nleaves)
vertices$angle <- 90 - 360 * vertices$id / nleaves

# Calculate the alignment of labels: right or left
# If on the left part of the plot, labels have currently an angle < -90
vertices$hjust <- ifelse(vertices$angle < -90, 1, 0)

# Flip angle to make them readable
vertices$angle <- ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)

# The connection object must refer to the ids of the leaves:
from <- match(connect$from, vertices$name)
to <- match(connect$to, vertices$name)

# Create a graph object with the igraph library
graph_ <- graph_from_data_frame(hierarchy, vertices=vertices)

# Plot hiearchical edge bundle
edgebundle <- ggraph(graph_, layout="dendrogram", circular=TRUE) +
  geom_conn_bundle(data=get_con(from=from, to=to), aes(colour=after_stat(index)), alpha=0.3, tension=1) + scale_edge_colour_distiller(palette = "GnBu") +
  geom_node_point(aes(filter=leaf, x = x*1.05, y=y*1.05), colour="gray60", size=2) +
  geom_node_text(aes(x=x*1.1, y=y*1.1, filter=leaf, label=name, angle=vertices$angle, hjust=vertices$hjust), alpha=1) +
  theme_void() + theme(legend.position="none") + expand_limits(x=c(-1.4, 1.4), y = c(-1.4, 1.4))

edgebundle <- ggraph(graph_, layout="dendrogram", circular=TRUE) + 
  geom_conn_bundle(data=get_con(from=from, to=to), aes(colour=after_stat(index)), alpha=0.3, tension=1) + scale_colour_manual(values=brewer.pal(nrow(years),"Paired")) + 
  scale_edge_colour_distiller(palette="GnBu") +
  geom_node_point(aes(filter=leaf, x = x*1.05, y=y*1.05, colour=group), size=2) + 
  geom_node_text(aes(x=x*1.1, y=y*1.1, filter=leaf, label=name, angle=vertices$angle, hjust=vertices$hjust), alpha=1) +
  theme_void() + theme(legend.position="none") + expand_limits(x=c(-1.4, 1.4), y = c(-1.4, 1.4))

# Save to file
edgebundle
ggsave("plots/citations-heb.png", plot=edgebundle, width=8.8, height=8.3, device="png", dpi="print")