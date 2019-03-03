## Checkes for libraries io server response status
## Parses the curl response for the listed license

library(readr)
library(dplyr)
library(tibble)
library(httr)
library(purrr)
library(magrittr)

prod_mature_packages <- readr::read_csv(here::here('./data/oss2/processed/working/pypi/production_ready.csv'))

simple_df <- prod_mature_packages %>%
  dplyr::select(name, html_save_path, on_server, last_pkg_dl_url, filename, src_save_path, file_downloaded, license, dev_status_clean) %>%
  dplyr::mutate(save_path = paste0('./data/oss2/original/pypi/libraries.io/', name, '.RDS')
  )

downloaded_get_responses <- list.files('./data/oss2/original/pypi/libraries.io', full.names = TRUE) %>%
  tibble(downloaded_librariesio_response_path = .,
         downloaded_librariesio_status = TRUE)

downloaded_get_responses %>% head()

simple_df$save_path[1:5]
downloaded_get_responses$downloaded_librariesio_response_path[1:5]

len1 <- nrow(simple_df)
len2 <- nrow(downloaded_get_responses)

any(duplicated(simple_df$save_path))
any(duplicated(downloaded_get_responses$downloaded_librariesio_response_path))

simple_df <- simple_df %>%
  dplyr::full_join(downloaded_get_responses, by = c('save_path' = 'downloaded_librariesio_response_path'))

# stopifnot(nrow(simple_df) == len1)
# after the pip downloads, this check no longer works, but there are no duplicated keys,
# this just means that there were different packages that were downloaded (and also packages downloaded from the original libraries call from the 03- set of scripts)

libraryio_responses <- simple_df %>%
  dplyr::filter(downloaded_librariesio_status == TRUE) %>%
  dplyr::mutate(librariesio_response = purrr::map(save_path, readr::read_rds),
                librariesio_status_code = purrr::map_int(librariesio_response, httr::status_code),
                librariesio_license_len = purrr::map_int(librariesio_response, ~ length(httr::content(.)[['normalized_licenses']]))
  )

tbl <- table(libraryio_responses$librariesio_status_code, useNA = 'always')
tbl

libraryio_responses %>%
  filter(librariesio_status_code != 200L) %>% pull(name)


tbl <- table(libraryio_responses$librariesio_license_len, useNA = 'always')
tbl
# only expect 0, 1, 2, 3, NA counts for number of normalized licenses
# making this check becuase i have to create separate dataframes for each count of normalized licenses and rbind
stopifnot(all(c("0", "1", "2", NA) %in% names(tbl)))
stopifnot(all(names(tbl) %in% c("0", "1", "2", "3", "4",  NA)))

# WHY DOESN"T THIS WORK!?
# libraryio_responses_all <- libraryio_responses %>%
#   dplyr::mutate(
#     libraries_license = dplyr::case_when(
#       librariesio_license_len == 0L ~ NA_character_,
#       librariesio_license_len == 1L ~ purrr::map_chr(librariesio_response, ~ httr::content(.)[['normalized_licenses']][[1]]),
#       librariesio_license_len == 2L ~ purrr::map_chr(librariesio_response, ~ httr::content(.)[['normalized_licenses']][[1]][[1]]) # take the first given license
#     )
#   )

# Since the above code doesn't seem to work, just filter by teach count type, and concatenate them together
libraryio_responses0 <- libraryio_responses %>%
  dplyr::filter(librariesio_license_len == 0L) %>%
  dplyr::mutate(l = NA)

libraryio_responses1 <- libraryio_responses %>%
  dplyr::filter(librariesio_license_len == 1L) %>%
  dplyr::mutate(l = purrr::map_chr(librariesio_response, ~ httr::content(.)[['normalized_licenses']][[1]]))

libraryio_responses2 <- libraryio_responses %>%
  dplyr::filter(librariesio_license_len == 2L) %>%
  dplyr::mutate(l = purrr::map_chr(librariesio_response, ~ httr::content(.)[['normalized_licenses']][[1]][[1]]))

libraryio_responses3 <- libraryio_responses %>%
  dplyr::filter(librariesio_license_len == 3L) %>%
  dplyr::mutate(l = purrr::map_chr(librariesio_response, ~ httr::content(.)[['normalized_licenses']][[1]][[1]]))

libraryio_responses4 <- libraryio_responses %>%
  dplyr::filter(librariesio_license_len == 4L) %>%
  dplyr::mutate(l = purrr::map_chr(librariesio_response, ~ httr::content(.)[['normalized_licenses']][[1]][[1]]))

libraryio_responses99 <- libraryio_responses %>%
  dplyr::filter(!librariesio_license_len %in% c(0L, 1L, 2L, 3L, 4L)) %>%
  dplyr::mutate(l = NA)

# the number of rows after concatenation should be the same
stopifnot(
  nrow(libraryio_responses0) +
    nrow(libraryio_responses1) +
    nrow(libraryio_responses2) +
    nrow(libraryio_responses3) +
    nrow(libraryio_responses4) +
    nrow(libraryio_responses99) ==

    nrow(libraryio_responses)
)

libraryio <- dplyr::bind_rows(libraryio_responses0, libraryio_responses1, libraryio_responses2, libraryio_responses3, libraryio_responses4, libraryio_responses99)

stopifnot(nrow(libraryio) == nrow(libraryio_responses))

readr::write_rds(libraryio, here::here('./data/oss2/processed/pypi/librariesio_licenses.RDS'))
