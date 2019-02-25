library(readr)
library(dplyr)
library(stringr)
library(tibble)

osi_licenses <- read_csv("data/oss2/original/osi_licenses.csv", 
                         col_names = FALSE)

# Clean the data from opensource.org ------------------------------------------

names(osi_licenses) <- 'full_name'

osi_licenses <- osi_licenses %>%
  dplyr::mutate(
    # extract the text bewteen the parenthesis
    paren = stringr::str_extract(full_name, '(?<=\\().+?(?=\\))'),
    
    # extract the text before the dash (to get the short license name)
    short = stringr::str_extract(paren, '.+?(?=-)')
    )

# if short is NA use the value in paren
osi_licenses$short[is.na(osi_licenses$short)] <- osi_licenses$paren[is.na(osi_licenses$short)]

# manually get the other missing values
osi_licenses %>% dplyr::filter(is.na(short))

osi_licenses$short[osi_licenses$full_name == 'BSD License: See 3-clause BSD License and 2-clause BSD License'] <- "BSD"
osi_licenses$short[osi_licenses$full_name == 'eCos License version 2.0'] <- "eCos"
osi_licenses$short[osi_licenses$full_name == 'OSET Public License version 2.1'] <- "OSET"
osi_licenses$short[osi_licenses$full_name == 'Upstream Compatibility License v1.0'] <- "Upstream Compatibility License"

testthat::expect_equal(sum(is.na(osi_licenses$short)), 0)
stopifnot(sum(is.na(osi_licenses$short)) == 0)

osi_licenses <- osi_licenses %>%
  dplyr::mutate(abbrev = stringr::str_to_lower(short))

# manually add for individual projects

# cran ----
cran_extra <- tibble::tribble(
  ~abbrev, ~full_name, 
  "gpl", "GNU General Public License (≥ 3)",
  "gpl", "GNU General Public License version 3",
  "mpl", "Mozilla Public License 2.0",
  "gpl", "GNU General Public License version 2 ",
  "cpl", "Common Public License Version 1.0",
  "lpl", "Lucent Public License",
  "cpl", "CPL-1.0",
  "mpl", "Mozilla Public License 1.1",
  "gpl", "GNU Affero General Public License"
)

cran_extra$note <- 'cran'

osi_licenses <- dplyr::bind_rows(osi_licenses, cran_extra)

# python -----
# julia -----







# Write out the osi approved license dataset ----------------------------------
readr::write_csv(osi_licenses, './data/oss2/original/osi_licenses_all_projects.csv')
