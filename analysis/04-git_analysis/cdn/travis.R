library(here)
library(tibble)
library(dplyr)

repos <- list.dirs('./data/oss2/original/cloned_repos/cdn', recursive = FALSE)

# 3074 cloned vs 3198 total repos

repos[[1]]

detect_travis <- function(repo_location, fname) {
  if (file.exists(paste0(repo_location, '/', fname))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

cloned <- tibble::tibble(
  repo_location = repos
)



t <- cloned %>%
  dplyr::mutate(travis = purrr::map_lgl(repo_location, detect_travis, fname = '.travis.yml'),
                license = purrr::map_lgl(repo_location, detect_travis, fname = 'license'),
                license2 = purrr::map_lgl(repo_location, detect_travis, fname = 'LICENSE')
                )

nrow(t) ## 3074

sum(t$travis) ## 1429
sum(t$license) ## 21
sum(t$license2) ## 1663
















