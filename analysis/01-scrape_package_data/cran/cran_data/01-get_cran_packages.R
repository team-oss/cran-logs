library(xml2)

cran_pkgs <- xml2::read_html('https://cran.r-project.org/web/packages/available_packages_by_name.html')

xml2::write_html(x = cran_pkgs,
                 sprintf('./data/oss2/original/cran/%s-cran-pkgs.html', Sys.Date()))
