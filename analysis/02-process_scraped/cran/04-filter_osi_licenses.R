library(readr)

crn_pkg_pg <- readr::read_rds('./data/oss2/processed/cran/cran_meta_licenses_raw.RDS')
osi_licenses <- read_csv(here::here('./data/oss2/original/osi_licenses_all_projects.csv'))

table(crn_pkg_pg$license_raw, useNA = 'always')

osi_apprev <- paste(unique(osi_licenses$abbrev), collapse = '|')
crn_pkg_pg$osi_approved <- stringr::str_detect(stringr::str_to_lower(crn_pkg_pg$license_raw), osi_apprev)
# TODO if you want to add the abbreviated license, you'd do it here

check_false_osi <- crn_pkg_pg[crn_pkg_pg$osi_approved == FALSE, c('license_raw', 'osi_approved')] %>% unique()
print(check_false_osi, n = 100)

# expecting 22 licenses to review
testthat::expect_equal(nrow(check_false_osi), 22)
stopifnot(nrow(check_false_osi) == 22)

# fill with cran_extra licenses
table(crn_pkg_pg$osi_approved, useNA = 'always')
crn_pkg_pg$osi_approved[crn_pkg_pg$license_raw %in% osi_licenses$full_name] <- TRUE
table(crn_pkg_pg$osi_approved, useNA = 'always')

# visual check to see if I didn't miss any more osi license that need to be manually added
# these should just be CC licenses and ACM
crn_pkg_pg %>%
  dplyr::select(license_raw, osi_approved) %>%
  dplyr::filter(osi_approved == FALSE) %>%
  unique()

readr::write_rds(crn_pkg_pg, here::here('./data/oss2/processed/cran/cran_osi_licenses.RDS'))
