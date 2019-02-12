## You will end up having to run this script over and over again due to the following error
## Not sure why it occurs, but running the script again seems to just run through the problematic url just fine
## could be a rate limit

## Error in curl::curl_fetch_memory(url, handle = handle) :
##   Error in the HTTP2 framing layer
## Calls: <Anonymous> ... request_fetch -> request_fetch.write_memory -> <Anonymous> -> .Call
## Execution halted

library(readr)
library(dplyr)
library(here)

osi_licences <- readr::read_csv(here::here("./data/oss/final/PyPI/osi_approved_licenses.csv"))
lio_licenses <- readr::read_rds(here::here('./data/oss2/processed/pypi/librariesio_licenses.RDS'))

table(lio_licenses$l)

any(unique(lio_licenses$l) %in% unique(osi_licences$full_name))

any(unique(lio_licenses$l) %in% unique(osi_licences$abbreviation))

already <- unique(lio_licenses$l) %in% unique(osi_licences$abbreviation)
unique(lio_licenses$l)[already]

unique(lio_licenses$l)[!already]

table(lio_licenses$l[lio_licenses$l %in% unique(lio_licenses$l)[!already]])

osi_approved = c('ZPL-2.1') # do not do the check until all libraries io packages are done downloading


lio_licenses <- lio_licenses %>%
  dplyr::mutate(osi_approved = dplyr::case_when(
    l %in% unique(osi_licences$full_name) ~ TRUE,
    l %in% unique(osi_licences$abbreviation)~ TRUE,
    TRUE ~ FALSE
  ))


table(lio_licenses$l, lio_licenses$osi_approved) %>% addmargins()

readr::write_rds(lio_licenses, here::here('./data/oss2/processed/pypi/osi_approved.RDS'))

lio_licenses %>%
  dplyr::filter(osi_approved == TRUE) %>%
  nrow()
