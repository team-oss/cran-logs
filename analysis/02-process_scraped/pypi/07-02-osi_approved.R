library(readr)
library(dplyr)
library(here)

# osi_licences <- readr::read_csv(here::here("./data/oss/final/PyPI/osi_approved_licenses.csv")) ## this was an older licence file
osi_licences <- readr::read_csv(here::here("./data/oss2/original/osi_licenses_all_projects.csv"))
lio_licenses <- readr::read_rds(here::here('./data/oss2/processed/pypi/librariesio_licenses.RDS'))

## the column l is the parsed license from librariesio. if the value is missing, just take the `license` from the metadata
## Just looking at the first 10 rows, 8 of the NA l values have a valid and easily parsed `license`

lio_licenses <- lio_licenses %>%
  dplyr::mutate(
    license_for_osi = dplyr::case_when(
      is.na(l) ~ stringr::str_to_lower(license),
      !is.na(l) ~ stringr::str_to_lower(l)
    )
  )


## get the manually shortened license (without version number) if it applies
get_base_license <- function(license_string) {
  if (is.na(license_string)) {
    return(NA)
  }
  # if there is a dash get the first part of the split
  if (stringr::str_detect(license_string, '-')) {
    splits <- stringr::str_split(license_string, '-')[[1]]
    first_part <- splits[[1]]
    return(first_part)
  } else {
    return(license_string)
  }
}

lio_licenses <- lio_licenses %>%
  dplyr::mutate(license_for_osi = purrr::map_chr(license_for_osi, get_base_license),
                license
                )

 
# table(lio_licenses$license_for_osi, useNA = 'always')
# 
# any(unique(lio_licenses$l) %in% unique(osi_licences$full_name)) # licences io results are all reporting some version of an abbreviation
# any(unique(lio_licenses$l) %in% unique(osi_licences$short)) ## things match here
# any(unique(lio_licenses$l) %in% unique(osi_licences$abbrev)) ## thigs don't match here, but that's becuase i converted all to lower-case, you want to use this one because the short has NA in it

## what licenes already match (so I can manually add the rest into the master licence file)
## convert everything to lower-case
already <- unique(lio_licenses$license_for_osi) %in% unique(osi_licences$abbrev)
unique(lio_licenses$license_for_osi)[already]

## these are the license values that do not have string matches in the master file
unique(lio_licenses$license_for_osi)[!already]

## now let's do a string detect for matches
licence_patterns <- paste(unique(osi_licences$abbrev), collapse = '|')
already_detect <- stringr::str_detect(unique(lio_licenses$license_for_osi),
                                      licence_patterns)

## ones that are detected
unique(lio_licenses$license_for_osi)[already_detect]

## ones that aren't detected
unique(lio_licenses$license_for_osi)[!already_detect]

# "gnu" "3" "psf"
lio_licenses %>%
  dplyr::filter(license_for_osi %in% c("gnu","3", "psf")) %>%
  dplyr::select(license, l, license_for_osi)


# mark as osi approved -----

## This part differes from CRAN a little bit, but the master license file shows that there is a python column i'm using for comparison instead of the raw main license file

lio_licenses <- lio_licenses %>%
  dplyr::mutate(osi_approved = dplyr::case_when(
    license_for_osi %in% unique(osi_licences$abbrev) ~ TRUE,
    stringr::str_detect(license_for_osi, licence_patterns) ~ TRUE,
    TRUE ~ FALSE # otherwise
  ))

table(lio_licenses$osi_approved, useNA = 'always') %>% addmargins()
table(lio_licenses$license_for_osi, lio_licenses$osi_approved, useNA = 'always') %>% addmargins()
table(lio_licenses$l, lio_licenses$osi_approved, useNA = 'always') %>% addmargins()
t <- table(lio_licenses$l, lio_licenses$osi_approved, useNA = 'always') %>% addmargins()
t %>% as.data.frame() %>% dplyr::filter(Var2 == FALSE, Freq != 0) # make sure nothing tagged as FALSE is an OSI license

readr::write_rds(lio_licenses, here::here('./data/oss2/processed/pypi/osi_approved.RDS'))

lio_licenses %>%
  dplyr::filter(osi_approved == TRUE) %>%
  nrow() ## 30909



lio_licenses$name
