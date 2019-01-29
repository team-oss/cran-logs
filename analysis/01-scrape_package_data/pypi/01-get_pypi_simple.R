library(rvest)

pypi_pkgs <- xml2::read_html('https://pypi.org/simple/')

xml2::write_html(x = pypi_pkgs,
                 sprintf('./data/oss2/original/pypi/%s-pypi_simple.html', Sys.Date()))
