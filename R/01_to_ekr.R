#' @title Convert measurement value to EKR
#' @description This function converts a measurement value to EKR
#' @param x The measurement value (chlfa in ug/l, waterdiepte_grens(met/zonder planten) in m, and bedekking in %)
#' @param watertype The water body type
#' @param deelmaatlat The part of the measurement value
#' @return The EKR value
#' @export
#' @examples
#' to_ekr(10.99, "M6b", "chlfa")





#From here --------------------------------------------------------------------
#Load default data from CSV file: a default dataframe of the ekr reference matrics


# Define function
to_ekr <- function(x, watertype, deelmaatlat){


                    data("ekr_ref", package = "ekrConverter")

                    mat <- ekr_ref %>% 
                           filter(maatlat %like% deelmaatlat) %>% 
                           select(watertype, 'ekr', 'maatlat')

                    #if under column watertype, there is no value, then return NA
                    len <- unique(mat %>% select(watertype))
                    if(nrow(len) == 1 && is.na(len)){
                      return(NA)
                    }      
                    
                    d <- data.frame(v1 = x, v2 = NA, v3 = NA)
                    colnames(d) <- colnames(mat)
                    
                    new_mat <- rbind(d, mat) %>% 
                               as_tibble() %>% 
                               arrange((!!sym(watertype)))
                    
                    pos <- which(is.na(new_mat$ekr))
                    
                    if(pos == 1){
                      
                      ekr <- as.numeric(new_mat[pos + 1, 'ekr'])
                      
                    }else if(pos %in% c(7, 13)){
                      
                      ekr <- as.numeric(new_mat[pos - 1, 'ekr'])
                      
                    }else {
                      
                      df1 <- new_mat[pos + 1, c('ekr', watertype)]
                      df2 <- new_mat[pos - 1, c('ekr', watertype)]
                      
                      if(df1$ekr < df2$ekr){
                              
                              onder <- df1
                              boven <- df2
                              ekr <- (x - as.numeric(onder[, watertype]))/(as.numeric(boven[, watertype]) - as.numeric(onder[, watertype])) * 0.2 + onder$ekr
                              
                      }else if(df1$ekr > df2$ekr){
                              onder <- df2
                              boven <- df1
                              ekr <- (x - as.numeric(onder[, watertype]))/(as.numeric(boven[, watertype]) - as.numeric(onder[, watertype])) * 0.2 + onder$ekr
                        
                      }
                      
                    }


                    return(ekr)


}

#To here ----------------------------------------------------------------------
