---
title: "package_counts"
output: 
  html_document: 
    keep_md: yes
    toc: yes
editor_options: 
  chunk_output_type: console
---


```r
library(here)
library(readr)
library(dplyr)
library(rvest)
library(tibble)

knitr::opts_chunk$set(message = FALSE)
```


# CRAN

### Total

Total number of cran packages


```r
cran_pkgs <- readr::read_csv(here::here('./data/oss2/processed/pkg_links.csv'))
```

Total number of cran packages


```r
TOTAL_CRAN <- nrow(cran_pkgs)
stopifnot(TOTAL_CRAN == length(unique(cran_pkgs$pkg_name)))
TOTAL_CRAN
```

```
## [1] 13719
```

### Production

Total number of production ready packages


```r
cran_production_status <- readr::read_csv(here::here('./data/oss2/processed/cran/cran_prod_rdy.csv'))

table(cran_production_status$production_ready, useNA = 'always')
```

```
## 
## FALSE  TRUE  <NA> 
##   369 13350     0
```


```r
PRODUCTION_CRAN <- cran_production_status %>% dplyr::filter(production_ready == TRUE) %>% nrow()
PRODUCTION_CRAN
```

```
## [1] 13350
```

### OSI

Total number of OSI packages


```r
cran_osi_status <- readr::read_rds(here::here('./data/oss2/processed/cran/cran_osi_licenses.RDS'))
table(cran_osi_status$osi_approved, useNA = 'always')
```

```
## 
## FALSE  TRUE  <NA> 
##   215 13504     0
```


```r
OSI_CRAN <- cran_osi_status %>% dplyr::filter(osi_approved == TRUE) %>% nrow()
OSI_CRAN
```

```
## [1] 13504
```

Production ready packages with OSI approved licenses


```r
prod <- readr::read_csv(here::here('./data/oss2/processed/cran/cran_prod_rdy.csv'))
osi <- readr::read_rds(here::here('./data/oss2/processed/cran/cran_osi_licenses.RDS'))
stopifnot(nrow(osi) == nrow(prod))
prod_osi <- dplyr::full_join(prod, osi, by = c('pkg_name', 'pkg_description', 'pkg_links', 'pkg_path'))
stopifnot(nrow(prod_osi) == nrow(prod))
```


```r
addmargins(table(prod_osi$production_ready, prod_osi$osi_approved, useNA = 'always'))
```

```
##        
##         FALSE  TRUE  <NA>   Sum
##   FALSE     8   361     0   369
##   TRUE    207 13143     0 13350
##   <NA>      0     0     0     0
##   Sum     215 13504     0 13719
```

### Prod + OSI


```r
cran_production_osi_status <- readr::read_rds(here::here(
  './data/oss2/processed/cran/production_ready_osi_approved.RDS'))

PRODUCTION_OSI_CRAN <- nrow(cran_production_osi_status)
PRODUCTION_OSI_CRAN
```

```
## [1] 13143
```

### Prod + OSI + GH

Production ready, OSI approved packages with a github slug


```r
github_cran <- readr::read_rds(here::here('./data/oss2/processed/cran/production_osi_gh.RDS'))
```


```r
table(!is.na(github_cran$gh_slug), useNA = 'always') %>% addmargins()
```

```
## 
## FALSE  TRUE  <NA>   Sum 
##     9  4407     0  4416
```



```r
PROD_OSI_GH_CRAN <- github_cran %>% dplyr::filter(!is.na(gh_slug)) %>% nrow()
```

### GH Cloned

Production ready, OSI approved packages with a github slug that were cloned


```r
cloned <- list.dirs(here::here('./data/oss2/original/cloned_repos/cran'),
                    full.names = TRUE, recursive = FALSE)

CLONED_CRAN <- length(cloned)
CLONED_CRAN
```

```
## [1] 4386
```


# Python

### Total


```r
pypi_pkgs <- xml2::read_html(here::here(
  './data/oss2/original/pypi/pypi_simple/2019-01-23-pypi_simple.html'))

pkg_urls <- pypi_pkgs %>%
  rvest::html_nodes('a') %>%
  rvest::html_attr('href')
```


```r
TOTAL_PYPI <- length(pkg_urls)
TOTAL_PYPI
```

```
## [1] 165738
```

### Production



```r
prod_mature_packages <- readr::read_csv(here::here(
  './data/oss2/processed/working/pypi/production_ready.csv'))

prod_mature_packages$dev_status_clean %>% table(useNA = 'always') %>% addmargins()
```

```
## .
##            mature production/stable              <NA>               Sum 
##               326             17156                 0             17482
```


```r
PRODUCTION_PYPI <- prod_mature_packages %>%
  dplyr::filter(dev_status_clean %in% c('production/stable', 'mature')) %>%
  nrow()
PRODUCTION_PYPI
```

```
## [1] 17482
```

### OSI


```r
osi_pypi <- readr::read_rds(here::here('./data/oss2/processed/pypi/osi_approved.RDS'))

table(osi_pypi$osi_approved, useNA = 'always') %>% addmargins()
```

```
## 
## FALSE  TRUE  <NA>   Sum 
##  8342 30909     0 39251
```


```r
OSI_PYPI <- osi_pypi %>%
  dplyr::filter(osi_approved == TRUE) %>%
  nrow()
```

### Prod + OSI

Production ready and OSI


```r
prod_rdy <- readr::read_csv(here::here('./data/oss2/processed/working/pypi/production_ready.csv'))
prod_rdy <- dplyr::mutate(prod_rdy, prod_rdy = dev_status_clean == 'production/stable' | dev_status_clean == 'mature')

osi_appr <- readr::read_rds(here::here('./data/oss2/processed/pypi/osi_approved.RDS'))
prod_osi_status <- dplyr::full_join(prod_rdy, osi_appr, by = c('name'))
```

`prod_osi_status$prod_rdy` as rows; `prod_osi_status$osi_approved` are columns

```r
table(prod_osi_status$prod_rdy, prod_osi_status$osi_approved, useNA = 'always') %>% addmargins()
```

```
##       
##        FALSE  TRUE  <NA>   Sum
##   TRUE  2439 15043     0 17482
##   <NA>  5903 15866     0 21769
##   Sum   8342 30909     0 39251
```



```r
PRODUCTION_OSI_PYPI <- dplyr::filter(prod_osi_status,
                          prod_rdy == TRUE,
                          osi_approved == TRUE) %>%
  nrow()
PRODUCTION_OSI_PYPI
```

```
## [1] 15043
```

### Prod + OSI + GH



```r
prod_osi_gh_pypi <- readr::read_rds(here::here('./data/oss2/processed/pypi/prod_osi_gh.RDS'))
```


```r
PROD_OSI_GH_PYPI <- nrow(prod_osi_gh_pypi)
```

### GH Cloned

Production ready with OSI approved licenses that were downloaded for analysis in github.


```r
CLONED_PYPI <- dir.exists(here::here(prod_osi_gh_pypi$gh_clone_path)) %>% sum(na.rm = TRUE)
CLONED_PYPI
```

```
## [1] 10609
```


# Complete Table Count


```r
all_cts <- tibble::tribble(
  ~Variable,              ~CRAN,               ~PyPI,               ~Julia, ~CDN,
  "Total",                TOTAL_CRAN,          TOTAL_PYPI,          NA,     NA,
  "Production Ready",     PRODUCTION_CRAN,     PRODUCTION_PYPI,     NA,     NA,
  "OSI Approved License", OSI_CRAN,            OSI_PYPI,            NA,     NA, 
  "Prod + OSI",           PRODUCTION_OSI_CRAN, PRODUCTION_OSI_PYPI, NA,     NA, 
  "Prod + OSI + Github",  PROD_OSI_GH_CRAN,    PROD_OSI_GH_PYPI,    NA,     NA,
  "Cloned",               CLONED_CRAN,         CLONED_PYPI,         NA,     NA
) %>%
  dplyr::mutate(cran_pypi = CRAN + PyPI)
knitr::kable(all_cts)
```



Variable                 CRAN     PyPI  Julia   CDN    cran_pypi
---------------------  ------  -------  ------  ----  ----------
Total                   13719   165738  NA      NA        179457
Production Ready        13350    17482  NA      NA         30832
OSI Approved License    13504    30909  NA      NA         44413
Prod + OSI              13143    15043  NA      NA         28186
Prod + OSI + Github      4407    11016  NA      NA         15423
Cloned                   4386    10609  NA      NA         14995
