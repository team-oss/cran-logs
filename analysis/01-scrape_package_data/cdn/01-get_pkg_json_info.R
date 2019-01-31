library(httr)
library(magrittr)
library(jsonlite)
library(progress)
library(here)
library(stringr)

response = httr::GET(url = 'https://api.cdnjs.com/libraries/') %>%
  httr::content(as = 'text', encoding = 'UTF-8') %>%
  jsonlite::fromJSON()

pkg_names <- response$results$name
pkg_names

pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = length(pkg_names))
pb$tick(0)

for (i in seq_along(pkg_names)) {
  name <- pkg_names[[i]]
  
  fp <- str_c(here::here('./data/oss2/original/cdn/libraries_json/'), name, '.json')
  
  if (file.exists(fp)) {
    next
  } else {
    tryCatch({
      res <- GET(url = str_c("https://api.cdnjs.com/libraries/", name)) %>%
        content(as = 'text', encoding = 'UTF-8') %>%
        fromJSON()
      jsonlite::write_json(x = res, path = fp)
    }, error = function(e) {
      if (!interactive()) {
        print(sprintf('Failed: %s', fp))
      }
    })
  }
  Sys.sleep(runif(1))
  pb$tick(1)
}

print('Done.')
