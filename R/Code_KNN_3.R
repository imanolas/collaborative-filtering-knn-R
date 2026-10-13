library("openxlsx")
library("dplyr")
library("qpcR")

# Help function for correlation

for_cor <- function (df){
  as.numeric(unlist(df))
}

# Code of part(a), the implementation of KNN algorithm
# -------------Set options of Algorithm-----------------

# Init Number of KNNs 
NUMBER_OF_N=3

# Set types of cor function() 
method_name = "pearson"
use_type = "complete"

remove_NAs = TRUE

# Init variables & lists
cor_for_NU1 <- NULL
cor_for_NU2 <- NULL

predicted_ratings_NU1 <- NULL
predicted_ratings_NU2 <- NULL

best_votes_for_NU1 <- NULL
best_votes_for_NU2 <- NULL

best_3nns_for_NU1 <- NULL
best_3nns_for_NU2 <- NULL

# --------------Code of part(b)--------------------
# Read the data from .csv
# @u_data for USERS_DATA
# @nu_data for NEW_USERS_DATA

U_data <- read.csv("u_data.csv",sep=";")
NU_data <- read.csv("nu_data.csv",sep=";")

# Transpose arrays of users and new users
df_U <- as.data.frame(t(U_data[,-1]))
len_of_users = length(df_U)
df_NU <- as.data.frame(t(NU_data[,-1]))
len_of_nusers = length(df_NU)

# Name and number of movies
column_names <- rownames(df_U)
number_of_movies = length(column_names)

# Compute the correlation values, type of pearson
for(i in 1:len_of_users){
  cor_for_NU1[i] = cor(for_cor(df_U[i]), as.numeric(df_NU$V1),method=method_name, use=use_type)
  cor_for_NU2[i] = cor(for_cor(df_U[i]), as.numeric(df_NU$V2),method=method_name, use=use_type)
}

# --------------Code of part(c)--------------------
# Implementation of KNN's algorithm
# @Number_of_nearest_neighbors = 3

best_3nns_for_NU1 <- tail(order(cor_for_NU1),NUMBER_OF_N)
best_3nns_for_NU2 <- tail(order(cor_for_NU2),NUMBER_OF_N)

best_votes_for_NU1 <- as.data.frame(df_U[c(best_3nns_for_NU1)])
best_votes_for_NU2 <- as.data.frame(df_U[c(best_3nns_for_NU2)])

# Compute the final predicted ratings for new users used Weighted Mean Average
for(i in 1:number_of_movies){
  predicted_ratings_NU1[i] = weighted.mean(unlist(best_votes_for_NU1[i,]), dplyr::coalesce(cor_for_NU1[best_3nns_for_NU1],0), na.rm = remove_NAs)
  predicted_ratings_NU2[i] = weighted.mean(unlist(best_votes_for_NU2[i,]), dplyr::coalesce(cor_for_NU2[best_3nns_for_NU2],0), na.rm = remove_NAs)
}

# Compute stats of predicted values
# @abs_error_for_NU1
# @abs_error_for_NU2
# @mae_for_NU1
# @mae_for_NU2

error_for_NU1 <- abs(predicted_ratings_NU1 - df_NU$V1)
error_for_NU2 <- abs(predicted_ratings_NU2 - df_NU$V2)

mae_for_NU1 <- mean(error_for_NU1, na.rm=remove_NAs)
mae_for_NU2 <- mean(error_for_NU2, na.rm=remove_NAs)

# Find movies tha new users did not rate
movies_not_rating_NU1 <- column_names[which(is.na(df_NU$V1))]
movies_not_rating_NU2 <- column_names[which(is.na(df_NU$V2))]

NU1_final_ratings <- predicted_ratings_NU1[which(is.na(df_NU$V1))]
NU2_final_ratings <- predicted_ratings_NU2[which(is.na(df_NU$V2))]

# Export final data to excel file, with the same format as the solved exercise in excel
# Bind columns and rows of new data to initial data
final_binded_data <- cbind(U_data,c(""),round(cor_for_NU1,4),round(cor_for_NU2,4),c(""))
final_binded_data <- qpcR:::cbind.na(final_binded_data,c(round(NU1_final_ratings,6), round(NU2_final_ratings,6)),
                                c(paste("NU1,",movies_not_rating_NU1),paste("NU2,",movies_not_rating_NU2)))


final_binded_data<- qpcR:::rbind.na(final_binded_data,c(""),c("NU1",round(predicted_ratings_NU1,6)),c("AbsErr",round(error_for_NU1,6)),c(""),
                               c("NU2",round(predicted_ratings_NU2,6)),c("AbsErr",round(error_for_NU2,6)),c(""),c("MAE NU1",round(mae_for_NU1,6)),c("MAE NU2",round(mae_for_NU2,6)))

colnames(final_binded_data) <- c("USERS",column_names,"","r_for_NU1","r_for_NU2","","Calc'ed rating with user-based collaborative filtering","")

# Write the final data in .xlsx file
write.xlsx(final_binded_data, 'final_predicted_data.xlsx',col.names = TRUE, row.names = FALSE,index = FALSE)
