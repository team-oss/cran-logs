library(readr)
library(dplyr)
library(here)

prod_mature_packages <- readr::read_csv(here::here('./data/oss2/processed/working/pypi/production_ready.csv'))

simple_df <- prod_mature_packages %>%
  
  dplyr::select(name, html_save_path, on_server, last_pkg_dl_url, filename, src_save_path, file_downloaded, license, dev_status_clean) %>%
  dplyr::mutate(api_url = paste0("https://libraries.io/api/pypi/", name,
                                 "?api_key=", Sys.getenv('LIBRARIES_IO_API_KEY')),
                save_path = paste0('./data/oss2/original/pypi/libraries.io/', name, '.RDS')
                )
head(simple_df)

# 16365 / 60 / 60 = ~4.5 Hours
total_iterations <- length(simple_df$api_url)
for (i in seq_along(simple_df$api_url)) {
  # i <- 1
  url <- simple_df$api_url[[i]]
  save_path <- here::here(simple_df$save_path[[i]])
  
  print(sprintf('%s / %s (%s)', i, total_iterations, i / total_iterations))
  print(url)
  print(save_path)
  
  if (file.exists(save_path)) {
    next
  } else {
    api_response <- httr::GET(url)
    
    saveRDS(api_response, file = save_path)
    # All requests are subject to a 60/request/minute rate limit based on your api_key,
    # any further requests within that timeframe will result in a 429 response.
    Sys.sleep(1.5)
  }
  #break
}
