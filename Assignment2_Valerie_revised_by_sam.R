### Homework Assignment 2
install.packages("dplyr")
install.packages("magrittr")
install.packages("tidyverse")
library("dplyr")
library("magrittr")
library("tidyverse")


source("./yelp_api_key.R") 



base_uri <- "https://api.yelp.com/v3/" 
end_point <- "businesses/search"
search_uri <- paste0(base_uri, end_point)
print(search_uri)

search_uri <- "https://api.yelp.com/v3/businesses/search"
query_params <- list(
  term = "restaurant",
  categories = "mexican",
  location = "Winston-Salem NC",
  sort_by = "rating",
  radius = 10000
)


library("httr") 
response <- GET( 
  search_uri,
  query = query_params,
  add_headers(Authorization = paste("bearer", yelp_key))
)

response_text <- content(response, type = "text") 
library("jsonlite") 
response_data <- fromJSON(response_text) 

restaurants <- flatten(response_data$businesses)
#View(restaurants)

library(dplyr)
restaurants <- restaurants %>%
  filter(review_count >= 30) %>%
  arrange(-rating) %>%
  mutate(Rank = row_number()) %>%
  mutate("Restaurant Name" = name) %>%
  mutate(Rating = rating) %>%
  mutate("Review Count" = review_count) %>%
  mutate("Address" = paste0(location.address1, location.city, location.zip_code, location.state)) %>%
  mutate("Phone Number" = phone) %>%
  select(Rank, "Restaurant Name", Rating, "Review Count", Address, "Phone Number")

View(restaurants)
write.csv(restaurants, file = "./ws_mexican_restuarants.csv", append = FALSE, 
          row.names = FALSE)

getwd()
install.packages("dbplyr")
library("DBI")
install.packages("RSQLite")
library("RSQLite")

db_connection <- dbConnect(SQLite(), dbname = "c:/Users/valer/Desktop/sqlite3/dsc510.db")
dbListTables(db_connection)

restuarants_table <- tbl(db_connection, "restuarants_table")
restuarants_table

s_restaurants <- restuarants_table %>%
  filter(Rating >= 4.5) %>%
  select(Rank, "Restaurant Name", Rating, "Phone Number")
s_restaurants  
