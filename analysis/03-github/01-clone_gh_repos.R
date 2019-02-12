library(readr)
library(here)
library(dplyr)
library(stringr)
library(git2r)
library(progress)

# CDN -----

cdn_gh <- readr::read_csv(here::here('./data/oss2/processed/cdn/cdn_gh_slugs.csv'))

cdn_gh <- cdn_gh %>%
  dplyr::mutate(clone_urls = stringr::str_c('https://github.com/', gh_slug,'.git'),
                repo_name = stringr::str_extract(gh_slug, '(?<=/).*'),
                repo_save_path = stringr::str_c('./data/oss2/original/cloned_repos/cdn/', repo_name)
                )

total <- length(cdn_gh$clone_urls)
pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = total)
pb$tick(0)
for (i in seq_along(cdn_gh$clone_urls)) {
  # i <- 1
  url <- cdn_gh$clone_urls[[i]]
  rpath <- here::here(cdn_gh$repo_save_path[[i]])
  if(!interactive()) {
    print(sprintf('%s / %s', i, total))
    print(url)
    print(rpath)
  }
  
  tryCatch({
    if (dir.exists(rpath)) {
      git2r::pull(repo = rpath)
    } else {
      git2r::clone(url = url, local_path = rpath, progress = TRUE)
    }
    pb$tick(1)
    Sys.sleep(runif(1))
    #break
  }, error = function(e){
    pb$tick(1)
    Sys.sleep(runif(1))
  })
  
}
