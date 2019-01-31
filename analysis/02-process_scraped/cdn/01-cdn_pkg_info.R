library(here)
library(jsonlite)
library(purrr)
library(tibble)
library(dplyr)
library(stringr)

json_to_df <- function(json_obj, group_then_spread = FALSE) {
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


cdn_info <- dplyr::bind_rows(safe_results$result, error_df)

stopifnot(nrow(cdn_info) == length(json_files))
