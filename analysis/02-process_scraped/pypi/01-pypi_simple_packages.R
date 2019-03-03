library(rvest)
library(xml2)
library(scales)
library(yaml)

pypi_pkgs <- xml2::read_html(here::here('./data/oss2/original/pypi/pypi_simple/2019-01-23-pypi_simple.html'))
yaml_f <- './data/oss2/processed/pkg_counts/pkg_counts.yml'
this_script_n <- '01-pypi_simple_packages.R'
pypi_pkgs_yml <- yaml::read_yaml(yaml_f)

links <- pypi_pkgs %>%
  html_nodes('a')

pkg_names <- links %>% rvest::html_text()

# number of pypi packages
scales::comma(length(pkg_names))

print(sprintf('Number of packages: %s', scales::comma(length(pkg_names))))

total_pkg_count <- length(pkg_names)
pypi_pkgs_yml$python$start$value <- total_pkg_count
pypi_pkgs_yml$python$start$from <- this_script_n
yaml::write_yaml(pypi_pkgs_yml, file = yaml_f)

head(pkg_names)
tail(pkg_names)

pkg_urls <- pypi_pkgs %>%
  html_nodes('a') %>%
  html_attr('href')

# check to make sure the lengh of package names match lenth of package urls
stopifnot(length(pkg_names) == length(pkg_urls))

