# Hiearchical edge bundling
# https://r-graph-gallery.com/hierarchical-edge-bundling

install.packages("ggraph")
install.packages("igraph")

library(ggraph)
library(igraph)

# create a data frame giving the hierarchical structure of your individuals. 
# Origin on top, then groups, then subgroups
d1 <- data.frame(from="origin", to=paste("G", seq(1,10), sep=""))
d2 <- data.frame(from=rep(d1$to, each=10), to=paste("P", seq(1,100), sep=""))
hierarchy <- rbind(d1, d2)

# create a dataframe with connection between leaves (individuals)
all_leaves <- paste("P", seq(1,100), sep="")
connect <- rbind( 
  data.frame(from=sample(all_leaves, 100, replace=T), to=sample(all_leaves, 100, replace=T)), 
  data.frame(from=sample(head(all_leaves), 30, replace=T), to=sample(tail(all_leaves), 30, replace=T)), 
  data.frame(from=sample(all_leaves[25:30], 30, replace=T), to=sample(all_leaves[55:60], 30, replace=T)), 
  data.frame(from=sample(all_leaves[75:80], 30, replace=T), to=sample(all_leaves[55:60], 30, replace=T)) 
)
connect$value <- runif(nrow(connect))

# create a vertices data.frame
# One line per object of our hierarchy, giving features of nodes
vertices <- data.frame(name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to))))
vertices$group <- hierarchy$from[match(vertices$name, hierarchy$to)]

# Add information concerning the label we are going to add: angle, horizontal adjustement and potential flip
# calculate the ANGLE of the labels
vertices$id <- NA
match_ <- which(is.na(match(vertices$name, hierarchy$from)))
nleaves <- length(match_)
vertices$id[match_] <- seq(1:nleaves)
vertices$angle <- 90 - 360 * vertices$id / nleaves

# calculate the alignment of labels: right or left
# If on the left part of the plot, labels have currently an angle < -90
vertices$hjust <- ifelse(vertices$angle < -90, 1, 0)

# flip angle BY to make them readable
vertices$angle <- ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)

# The connection object must refer to the ids of the leaves:
from <- match(connect$from, vertices$name)
to <- match(connect$to, vertices$name)

# Create a graph object with the igraph library
graph_ <- graph_from_data_frame(hierarchy, vertices=vertices)

# plot
ggraph(graph_, layout = 'dendrogram', circular = TRUE) + 
  geom_conn_bundle(data = get_con(from = from, to = to), aes(colour=after_stat(index)), alpha=0.2, tension = 1) + scale_edge_colour_distiller(palette = "GnBu") +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05), colour="grey", size=2) +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=name, angle = vertices$angle, hjust=vertices$hjust), alpha=1) +
  theme_void() + theme(legend.position = "none") + expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))