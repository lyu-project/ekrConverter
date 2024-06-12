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
van_ekr <- function (x, watertype, deelmaatlat) {


                    data("ekr_ref", package = "ekrConverter")

                    mat <- ekr_ref %>% 
                           filter(maatlat %like% deelmaatlat) %>% 
                           select(watertype, 'ekr', 'maatlat') %>%
                           as_tibble()

                    #if under column watertype, there is no value, then return NA
                    len <- unique(mat %>% select(watertype))
                    if (nrow(len) == 1 && is.na(len)) {

                      return(NA)
                    
                    }      
                    
                    d <- data.frame(v1 = NA, v2 = x, v3 = NA)
                    colnames(d) <- colnames(mat)
                    
 

                      
                    if (deelmaatlat %in% c('chlfa')) {


                        if (x == 0) {

                               print(paste0('concentratie > ', mat %>% filter(ekr == 0) %>% select(watertype)))

                        } else if (x == 1) {

                               print(paste0('concentratie < ', mat %>% filter(ekr == 1) %>% select(watertype)))

                        } else {


                                new_mat <- rbind(d, mat) %>% 
                                           as_tibble() %>% 
                                           arrange(ekr)
                              
                                pos <- which(is.na(new_mat[, watertype]))

                                
                                df1 <- new_mat[pos + 1, c('ekr', watertype)]
                                df2 <- new_mat[pos - 1, c('ekr', watertype)]
                                
                                if (df1[, watertype] < df2[, watertype]) {
                                        
                                        onder <- df1
                                        boven <- df2
                                        
                                } else if (df1[, watertype] > df2[, watertype]) {
                                        onder <- df2
                                        boven <- df1
                                  
                                }


                                conc <- (x - as.numeric(onder[, 'ekr']))/(as.numeric(boven[, 'ekr']) - as.numeric(onder[, 'ekr'])) * (boven[, watertype] - onder[, watertype]) + onder[, watertype]

                                return(as.numeric(conc))


                       }
    


                    } else {


                      if (x %in% c(0, 1)) {


                           print(mat %>% filter(ekr == x) %>% select(watertype) %>% unique())


                      } else {


                                new_mat_dec <- rbind(d, mat %>% filter(maatlat %like% 'dec')) %>% 
                                               as_tibble() %>% 
                                               arrange(ekr)
                                new_mat_inc <- rbind(d, mat %>% filter(maatlat %like% 'inc')) %>% 
                                               as_tibble() %>% 
                                               arrange(ekr)
                                pos_dec <- which(is.na(new_mat_dec[, 'maatlat']))
                                pos_inc <- which(is.na(new_mat_inc[, 'maatlat']))

                                
                                #value 1
                                if (is.na(new_mat_inc[pos_inc + 1, watertype]) && is.na(new_mat_inc[pos_inc - 1, watertype])){

                                         conc_1 <- NA

                                } else {

                                        df1 <- new_mat_inc[pos_inc + 1, c('ekr', watertype)]
                                        df2 <- new_mat_inc[pos_inc - 1, c('ekr', watertype)]
                                        
                                        if (is.na(as.numeric(df1[, watertype])) || is.na(as.numeric(df2[, watertype]))) {
                                               
                                                conc_1 <- ifelse(as.numeric(is.na(df1[, watertype])), as.numeric(df2[, watertype]), as.numeric(df1[, watertype]))

                                        } else {

                                        if (df1[, watertype] < df2[, watertype]) {
                                                
                                                onder <- df1
                                                boven <- df2
                                                
                                        } else if (df1[, watertype] > df2[, watertype]) {

                                                onder <- df2
                                                boven <- df1
                                        
                                        }


                                        conc_1 <- (x - as.numeric(onder[, 'ekr']))/(as.numeric(boven[, 'ekr']) - as.numeric(onder[, 'ekr'])) * (boven[, watertype] - onder[, watertype]) + onder[, watertype]
                                     
                                     }

                                }


                                #value 2

                                if (is.na(new_mat_dec[pos_dec + 1, watertype]) && is.na(new_mat_dec[pos_dec - 1, watertype])){

                                        conc_2 <- NA

                                } else {

                                        df1 <- new_mat_dec[pos_dec + 1, c('ekr', watertype)]
                                        df2 <- new_mat_dec[pos_dec - 1, c('ekr', watertype)]
                                
                                        if (is.na(as.numeric(df1[, watertype])) || is.na(as.numeric(df2[, watertype]))) {
                                               
                                                conc_2 <- ifelse(as.numeric(is.na(df1[, watertype])), as.numeric(df2[, watertype]), as.numeric(df1[, watertype]))

                                        } else {
                                        
                                        if (df1[, watertype] < df2[, watertype]) {
                                        
                                                onder <- df1
                                                boven <- df2
                                                
                                        } else if (df1[, watertype] > df2[, watertype]) {

                                                onder <- df2
                                                boven <- df1
                                        
                                        }

                                        conc_2 <- (x - as.numeric(onder[, 'ekr']))/(as.numeric(boven[, 'ekr']) - as.numeric(onder[, 'ekr'])) * (boven[, watertype] - onder[, watertype]) + onder[, watertype]
                                
                                     }
                                }

                                return(c(as.numeric(conc_1), as.numeric(conc_2)))

                           }    

                      
                    }




}

#To here ----------------------------------------------------------------------
