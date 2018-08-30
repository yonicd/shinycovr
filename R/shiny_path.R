#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param m PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  library(ShinyTester)
#'  
#'  x <- ShinyTester::ShinyHierarchy(system.file('shinyexample',package='shinycovr'))
#'  x$x$edges
#'  x$x$nodes
#'  
#'  # possible reactive paths
#'  shiny_path(x)
#'  }
#' }
#' @seealso 
#'  \code{\link[igraph]{as_data_frame}},\code{\link[igraph]{as_adjacency_matrix}}
#'  \code{\link[stats]{setNames}}
#' @rdname shiny_path
#' @export 
#' @importFrom igraph graph_from_data_frame as_adj
#' @importFrom stats setNames
shiny_path <- function(m){
  
  if(inherits(m,'visNetwork')){
  
    m_raw <- m
      
    m <- m$x$edges[,c('from','to')]
    
    m <- igraph::graph_from_data_frame(m,directed = TRUE)
  }
  
  if(inherits(m,'igraph')){
    m <- as.matrix(igraph::as_adj(m))
  }
  
  if(inherits(m,'dgCMatrix')){
    m <- as.matrix(m)
  }
  
  idx <- names(which(apply(m,2,sum)==0))  
  
  l <- stats::setNames(lapply(idx,function(x) traverse(x,m,x)),idx)
  
  fl <- unname(flattenlist(l))
  
  if(exists('m_raw')){
  
  sapply(fl,function(id){
    
    y <- x$x$nodes$label[x$x$nodes$id%in%id]
    
    idx <- match(x$x$nodes$id,id,nomatch = FALSE)
    idx <- idx[idx!=0]
    
    
    paste0(y[order(idx)],collapse='=>')
    
  })
  }else{
    
  sapply(fl,paste0,collapse = '=>')
    
  }
  
}
