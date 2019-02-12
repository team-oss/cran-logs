library(readr)
library(dplyr)

cdn <- readr::read_csv('./data/oss2/processed/cdn/cdn_with_license.csv')
osi <- readr::read_csv('./data/oss/final/PyPI/osi_approved_licenses.csv')

cdn$license_first

cdn_osi <- cdn %>%
  dplyr::mutate(osi_approved = license_first %in% osi$abbreviation) %>%
  dplyr::filter(osi_approved == TRUE)

osi$abbreviation
cdn_osi$osi_approved

readr::write_csv(cdn_osi, './data/oss2/processed/cdn/cdn_osi.csv')
