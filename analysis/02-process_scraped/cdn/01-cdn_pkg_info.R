library(here)
library(jsonlite)
library(purrr)
library(tibble)
library(dplyr)
library(stringr)

json_to_df <- function(json_obj, group_then_spread = FALSE) {
  # grouped_then_spread param accounts for comment below
  # Originally was going to make it so spread will always work
  # but this will cause the output dataframe to have multiple values (which would cause confusion later)
  # decided best to let the error happen, then deal with the problematic data as they occur
  #
  # Create a row id beacuse some (1) of the tables have duplicate identifiers
  # which will cause spread to fail
  # please see: the following examples
  # https://github.com/tidyverse/tidyr/issues/426
  # https://www.r-bloggers.com/workaround-for-tidyrspread-with-duplicate-row-identifiers/
  # https://stackoverflow.com/questions/45898614/how-to-spread-columns-with-duplicate-identifiers?rq=1
  # https://stackoverflow.com/questions/39053451/using-spread-with-duplicate-identifiers-for-rows
  
  df <- tibble::enframe(unlist(json_obj)) %>%
    dplyr::filter(!str_detect(name, 'assets'))
  
  if (group_then_spread) {
    df <- df %>%
      dplyr::group_by(name) %>%
      dplyr::mutate(grouped_id = row_number()) %>%
      tidyr::spread(name, value) %>%
      dplyr::select(-grouped_id) %>%
      dplyr::slice(1) %>% # return only the first row of results
      {.}
  } else {
    df <- df %>%
      tidyr::spread(name, value) %>%
      {.}
  }
  return(df)
}

get_fist_non_missing <- function(vec) {
  if (all(is.na(vec))) { # if everything is NA, return NA
    return(NA)
  } else {
    non_missing_values <- !is.na(vec)
    non_na_i <- which(non_missing_values)
    first <- non_na_i[[1]]
    return(vec[[first]])
  }
}

testthat::expect_equal(get_fist_non_missing(c(1, 2, 3, 4, 5)), 1)
testthat::expect_equal(get_fist_non_missing(c(NA, 2, 3, 4, 5)), 2)
testthat::expect_equal(get_fist_non_missing(c(NA, NA, NA)), NA)
testthat::expect_equal(get_fist_non_missing(c(NA)), NA)
testthat::expect_equal(get_fist_non_missing(c(42)), 42)
testthat::expect_equal(get_fist_non_missing(c(NA, NA, 3, NA, 5)), 3)

json_to_df_safe <- purrr::safely(json_to_df)

json_files <- list.files(here::here('./data/oss2/original/cdn/libraries_json/'), full.names = TRUE)
pkg_json <- purrr::map(json_files, jsonlite::fromJSON)

safe_results <- purrr::map(pkg_json, json_to_df_safe) %>%
  purrr::transpose()


# find and deal with the errors
error_i <- which(sapply(X = safe_results$result, FUN = is.null))
stopifnot(length(error_i) == 1) # 2019-01-31 only expect 1 problematic json value
safe_results$result[[error_i]]
safe_results$error[[error_i]]
pkg_json[[error_i]]

error_df <- json_to_df(pkg_json[[error_i]], group_then_spread = TRUE)


cdn_info <- dplyr::bind_rows(safe_results$result, error_df) %>%
  select(-tidyselect::contains('keywords'))

stopifnot(nrow(cdn_info) == length(json_files))

licenses_first <- cdn_info %>% select(tidyselect::contains('license')) %>%
  apply(X = ., MARGIN = 1, FUN = get_fist_non_missing)

cdn_info$license_first <- licenses_first

osi_licenses <- readr::read_csv('./data/oss/final/PyPI/osi_approved_licenses.csv')


cdn_info$license_first[!cdn_info$license_first %in% osi_licenses$abbreviation]

readr::write_csv(cdn_info, './data/oss2/processed/cdn/cdn_with_license.csv')
