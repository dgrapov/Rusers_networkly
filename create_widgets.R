
#create plotly plots
# 2D Karate network
library(igraph)
karate <- make_graph("Zachary")
karate$layout <- layout_with_kk(karate)

## Identify Graph Modules
fc <- cluster_fast_greedy(karate)
memb <- membership(fc)


## Network Objects
edge.list<-data.frame(get.edgelist(karate,names=TRUE))
edge.list$ID<-"friends"


### node attributes
nodes<-as.matrix(V(karate))
node.data<-data.frame(ID=nodes,group=as.matrix(memb))
#add color
node.data$color<-rainbow(length(unique(node.data$group)))[factor(node.data$group)]
#add size based on centrality
#rescale to 20-60
library(scales)
node.data$size<-rescale(closeness(karate, mode="all"),to=c(10,40))


## Recreate Plotly Network
library(networkly)

#net params
layout<-"kamadakawai"
type<-"2d"
color<-'color'
size<-'size'
name<-'ID'

obj<-get_network(edge.list,type=type,layout=layout)
#view
sapply(obj,head)
#create plotting attributes
net<-c(get_edges(obj,color=NULL,width=NULL,name=name,type=type,hoverinfo="none",showlegend=FALSE),
       get_nodes(obj,node.data,color=color,size=size,name=name,type=type,hoverinfo="ID",showlegend=FALSE),
       get_text(obj,node.data,text=name,extra=list(textfont=list(size=20)),type=type,yoff=-5,hoverinfo="none",showlegend=FALSE))


legend<-c(format_legend(obj,nodes=FALSE,node.data=node.data,width=NULL,size=NULL,name=name,color=NULL),#edge legend
          format_legend(obj,edges=FALSE,node.data=node.data,size=NULL,name=NULL,color="group")) #node legend


net2<-c(net,c(get_edges(legend,color=NULL,width=NULL,name=name,type=type,hoverinfo="none",showlegend=TRUE),
              get_nodes(legend,node.data=legend$node.data,color="group",size=NULL,name="group",type=type,showlegend=TRUE,merge=FALSE)))

net<-shiny_ly(net2) # with legend

p1<-plotly::layout(net,
               xaxis = list(title = "", showgrid = FALSE, showticklabels = FALSE, zeroline = FALSE, hoverformat = '.2f'),
               yaxis = list(title = "", showgrid = FALSE, showticklabels = FALSE, zeroline = FALSE, hoverformat = '.2f'))

setwd("www/html")
htmlwidgets::saveWidget(plotly::as.widget(p1), file='2D_plotly.html')



#net params
node.data$size<-rescale(closeness(karate, mode="all"),to=c(2,15))
layout<-"kamadakawai"
type<-"3d"
color<-'color'
size<-'size'
name<-'ID'
obj<-get_network(edge.list,type=type,layout=layout)
#view
sapply(obj,head)
#create plotting attributes
net<-c(get_edges(obj,color=NULL,width=NULL,name=name,type=type,hoverinfo="none",showlegend=FALSE),
       get_nodes(obj,node.data,color=color,size=size,name=name,type=type,hoverinfo="ID",showlegend=FALSE),
       get_text(obj,node.data,text=name,extra=list(textfont=list(size=10)),type=type,yoff=-5,hoverinfo="none",showlegend=FALSE))


legend<-c(format_legend(obj,nodes=FALSE,node.data=node.data,width=NULL,size=NULL,name=name,color=NULL),#edge legend
          format_legend(obj,edges=FALSE,node.data=node.data,size=NULL,name=NULL,color="group")) #node legend


net2<-c(net,c(get_edges(legend,color=NULL,width=NULL,name=name,type=type,hoverinfo="none",showlegend=TRUE),
              get_nodes(legend,node.data=legend$node.data,color="group",size=NULL,name="group",type=type,showlegend=TRUE,merge=FALSE)))

net<-shiny_ly(net2) # with legend

p2<-plotly::layout(net,scene = list(showlegend=TRUE,
                        yaxis=list(showgrid=FALSE,showticklabels=FALSE,zeroline=FALSE,title=""),
                        xaxis=list(showgrid=FALSE,showticklabels=FALSE,zeroline=FALSE,title=""),
                        zaxis=list(showgrid=FALSE,showticklabels=FALSE,zeroline=FALSE,title="")))

htmlwidgets::saveWidget(plotly::as.widget(p2), file='3D_plotly.html')

