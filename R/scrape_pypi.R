create_fname_url_html <- function(url,
                                  save_path_dir = here('./data/oss2/original/pypi/pypi_simple/simple_pkg_htmls/')) {
  pkg_name <- stringr::str_remove(url, "https://pypi.org/*simple/")
  pkg_name_clean <- stringr::str_remove_all(pkg_name, '/')
  save_path <- paste0(save_path_dir, pkg_name_clean, '.html')
  return(save_path)
}
