## You will end up having to run this script over and over again due to the following error
## Not sure why it occurs, but running the script again seems to just run through the problematic url just fine
## could be a rate limit

## Error in curl::curl_fetch_memory(url, handle = handle) :
##   Error in the HTTP2 framing layer
## Calls: <Anonymous> ... request_fetch -> request_fetch.write_memory -> <Anonymous> -> .Call
## Execution halted

library(readr)
library(dplyr)
library(here)

prod_mature_packages <- readr::read_csv(here::here('./data/oss2/processed/working/pypi/production_ready.csv'))

simple_df <- prod_mature_packages %>%
  dplyr::distinct(name_pypi, .keep_all = TRUE) %>%
  dplyr::select(name_pypi, name, html_save_path, on_server, last_pkg_dl_url, filename, src_save_path, file_downloaded, license, dev_status_clean) %>%
  dplyr::mutate(api_url = paste0("https://libraries.io/api/pypi/", name_pypi,
                                 "?api_key=", Sys.getenv('LIBRARIES_IO_API_KEY')),
                save_path = paste0('./data/oss2/original/pypi/libraries.io/', name_pypi, '.RDS')
                )
head(simple_df)

simple_df %>% dplyr::distinct() %>% nrow()
simple_df %>% nrow()

# 16365 / 60 / 60 = ~4.5 Hours
total_iterations <- length(simple_df$api_url)
for (i in seq_along(simple_df$api_url)) {
  # i <- 1
  url <- simple_df$api_url[[i]]
  save_path <- here::here(simple_df$save_path[[i]])
  
  if (file.exists(save_path)) {
    next
  } else {
    print(sprintf('%s / %s (%s)',
                  i,
                  total_iterations,
                  round(i / total_iterations, digits = 2)))
    print(url)
    print(save_path)
    
    #api_response <- httr::RETRY("GET", url, pause_base = 1, times = 10)
    api_response <- httr::GET(url)
    
    saveRDS(api_response, file = save_path)
    # All requests are subject to a 60/request/minute rate limit based on your api_key,
    # any further requests within that timeframe will result in a 429 response.
    Sys.sleep(1.5)
  }
  #break
}
