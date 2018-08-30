#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param parent PARAM_DESCRIPTION
#' @param adj PARAM_DESCRIPTION
#' @param chain PARAM_DESCRIPTION, Default: NULL
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[stats]{setNames}}
#' @rdname traverse
#' @export 
#' @importFrom stats setNames
traverse <- function(parent,adj,chain = NULL){
  
  children <- names(which(adj[parent,]==1))
  
  if(length(children)>0){
    
    stats::setNames(lapply(children,function(x,chain){
      chain <- c(chain,x)
      traverse(x,adj,chain) 
    },chain=chain),children)
    
  }else{
    
    chain
    
  }
  
}
