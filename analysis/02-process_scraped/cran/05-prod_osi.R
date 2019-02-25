library(readr)
library(here)
library(dplyr)

prod <- readr::read_csv(here::here('./data/oss2/processed/cran/cran_prod_rdy.csv'))
osi <- readr::read_rds(here::here('./data/oss2/processed/cran/cran_osi_licenses.RDS'))

prod
osi


stopifnot(nrow(osi) == nrow(prod))

prod_osi <- dplyr::full_join(prod, osi, by = c('pkg_name', 'pkg_description', 'pkg_links', 'pkg_path'))
stopifnot(nrow(prod_osi) == nrow(prod))

prod_ready <- prod_osi %>%
  dplyr::filter(production_ready == TRUE)
nrow(prod_ready) ## 13350

osi_approved <- prod_osi %>%
  dplyr::filter(osi_approved == TRUE)
nrow(osi_approved) ## 13504

prod_ready_osi_approved <- prod_osi %>%
  dplyr::filter(production_ready == TRUE,
                osi_approved == TRUE
                )
nrow(prod_ready_osi_approved) ## 13143

readr::write_rds(prod_ready_osi_approved, here::here('./data/oss2/processed/cran/production_ready_osi_approved.RDS'))
