# https://r-graph-gallery.com/309-intro-to-hierarchical-edge-bundling.html
# https://r-graph-gallery.com/310-custom-hierarchical-edge-bundling.html

# Install (if not installed) and load required packages
packages <- c("ggraph", "igraph", "RColorBrewer")
install.packages(setdiff(packages, rownames(installed.packages())))
invisible(lapply(packages, library, character.only = TRUE))

# Set current directory as work directory
setwd(".")

# Create hierarchy: root -> years (2013-2024) -> papers (Pn)
# arg 'times' corresponds to the number of papers for the year
years <- data.frame(from="root", to=seq(2013,2024))
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
  rep(2023, times=2),
  rep(2024, times=7)
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
  paste("P", seq(56,57), sep=""),
  paste("P", seq(58,64), sep="")
))
hierarchy <- rbind(years, papers)

# Create a dataframe with connection between leaves (individuals)
# Adjacency matrix comes from a CSV file
all_leaves <- paste("P", seq(1,nrow(papers)), sep="")
connect <- read.csv("data/crossref.csv", header=FALSE)
colnames(connect) <- c("citing", "cited")

# Create a vertices dataframe
vertices <- data.frame(name=unique(c(as.character(hierarchy$from), as.character(hierarchy$to))))
vertices$group <- hierarchy$from[match(vertices$name, hierarchy$to)]

# Add information concerning the label to be added: angle, horizontal adjustment, and potential flip
# Calculate the angle of the labels
vertices$id <- NA
match_ <- which(is.na(match(vertices$name, hierarchy$from)))
nleaves <- length(match_)
vertices$id[match_] <- seq(1:nleaves)
vertices$angle <- 90 - 360 * vertices$id / nleaves

# Calculate the alignment of labels (right or left)
# If on the left part of the plot, labels currently have an angle < -90
vertices$hjust <- ifelse(vertices$angle < -90, 1, 0)

# Flip angle to make them readable
vertices$angle <- ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)

# The connection object must refer to the IDs of the leaves
from <- match(connect$citing, vertices$name)
to <- match(connect$cited, vertices$name)

# Create a graph object with the igraph library
graph_ <- graph_from_data_frame(hierarchy, vertices=vertices)

# Plot hierarchical edge bundle
edgebundle <- ggraph(graph_, layout="dendrogram", circular=TRUE) +
  geom_conn_bundle(data=get_con(from=from, to=to), aes(colour=after_stat(index)), alpha=0.3, tension=1) + scale_edge_colour_distiller(palette = "GnBu") +
  geom_node_point(aes(filter=leaf, x = x*1.05, y=y*1.05), colour="gray60", size=2) +
  geom_node_text(aes(x=x*1.1, y=y*1.1, filter=leaf, label=name, angle=vertices$angle, hjust=vertices$hjust), alpha=1) +
  theme_void() + theme(legend.position="none") + expand_limits(x=c(-1.4, 1.4), y = c(-1.4, 1.4))
edgebundle

# Alternative for colored circles w.r.t. years
# edgebundle <- ggraph(graph_, layout="dendrogram", circular=TRUE) + 
#   geom_conn_bundle(data=get_con(from=from, to=to), aes(colour=after_stat(index)), alpha=0.3, tension=1) + scale_colour_manual(values=brewer.pal(nrow(years),"Paired")) + 
#   scale_edge_colour_distiller(palette="GnBu") +
#   geom_node_point(aes(filter=leaf, x = x*1.05, y=y*1.05, colour=group), size=2) + 
#   geom_node_text(aes(x=x*1.1, y=y*1.1, filter=leaf, label=name, angle=vertices$angle, hjust=vertices$hjust), alpha=1) +
#   theme_void() + theme(legend.position="none") + expand_limits(x=c(-1.4, 1.4), y = c(-1.4, 1.4))
# edgebundle

# Save to file
ggsave("plots/citations-heb.png", plot=edgebundle, width=8.7, height=8.3, device="png", dpi="print")