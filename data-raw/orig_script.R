library(igraph)
library(ShinyTester)

x <- ShinyTester::ShinyHierarchy('.')

shiny_path(x)

shiny_path <- function(m){
  
  if(inherits(m,'visNetwork')){
    
    m <- m$x$edges[,c('from','to')]
    
    m <- igraph::graph_from_data_frame(m,directed = TRUE)
  }
  
  if(inherits(m,'igraph')){
    m <- as.matrix(as_adj(m))
  }
  
  if(inherits(m,'dgCMatrix')){
    m <- as.matrix(m)
  }
  
  idx <- names(which(apply(m,2,sum)==0))  
  
  l <- setNames(lapply(idx,function(x) traverse(x,m,x)),idx)
  
  fl <- unname(flattenlist(l))
  
  sapply(fl,function(id){
    
    y <- x$x$nodes$label[x$x$nodes$id%in%id]
    
    idx <- match(x$x$nodes$id,id,nomatch = FALSE)
    idx <- idx[idx!=0]
    
    
    paste0(y[order(idx)],collapse=', ')
    
  })
  
}

traverse <- function(parent,adj,chain = NULL){
  
  children <- names(which(adj[parent,]==1))
  
  if(length(children)>0){
    
    setNames(lapply(children,function(x,chain){
      chain <- c(chain,x)
      traverse(x,adj,chain) 
    },chain=chain),children)
    
  }else{
    
    chain
    
  }
  
}

flattenlist <- function(x){  
  morelists <- sapply(x, function(xprime) class(xprime)[1]=="list")
  out <- c(x[!morelists], unlist(x[morelists], recursive=FALSE))
  if(sum(morelists)){ 
    Recall(out)
  }else{
    return(out)
  }
}