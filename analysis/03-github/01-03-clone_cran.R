library(readr)
library(here)
library(git2r)
library(dplyr)

cran <- readr::read_rds(here::here('./data/oss2/processed/cran/production_osi_gh.RDS'))

cran$gh_slug_valid <- stringr::str_detect(cran$gh_slug, '.+/.+')

table(cran$gh_slug_valid, useNA = 'always')

cran %>%
  dplyr::filter(gh_slug_valid == FALSE) %>%
  dplyr::select(pkg_name, url, gh_slug, gh_slug_valid) %>%
  print(n = 1000)

for (i in seq_along(cran$pkg_name)) {
  clone_url <- cran$gh_clone_url[[i]]
  clone_pth <- cran$gh_clone_path[[i]]
  clone_pth <- here::here(clone_pth)
  
  if (dir.exists(clone_pth)) {
    next
  } else {
    print(i)
    print(clone_url)
    print(clone_pth)
    git2r::clone(url = clone_url, local_path = clone_pth, progress = TRUE)
  }
  # break
}


cran[44, ]
