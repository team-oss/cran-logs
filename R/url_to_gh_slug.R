#' takes in a github url, returns the org/repo slug
#' @examples
#' parse_github_slug('github.com/bi-sdal/sdalr')
parse_github_slug <- function(github_url) {
  if (is.na(github_url)) {
    return(NA)
  } else if (stringr::str_detect(github_url, 'github.com')) {
    # regex for another time, let's not throw the kitchen sink when we don't have to
    # stringr::str_extract(github_url, '(?<=github\\.com/)(.*?/.*?/?)')
    after_github <- stringr::str_split_fixed(github_url, 'github.com(/|:)', 2)[, 2]
    slug_components <- stringr::str_split_fixed(after_github, '/', 3)[, c(1, 2)]
    collapsed <- paste(slug_components, collapse = '/')
    
    final_slug <- stringr::str_replace(collapsed, '\\.git', '')
    return(final_slug)
  } else if (stringr::str_detect(github_url, 'github.io')) { # account for github pages urls for repositoryes
    # e.g., https://ternarylabs.github.io/porthole/
    user <- str_extract(github_url, '(?<=https://).*(?=\\.github\\.io)')
    repo <- str_extract(github_url, '(?<=\\.github\\.io/).*(?=/?)')
    repo <- str_remove(repo, '/')
    final_slug <- stringr::str_c(user, repo, sep = '/')
    return(final_slug)
  } else if (stringr::str_detect(github_url, 'git://github')) {
    # assume the url looks like this: git://github.juven14/Collapsible.git
    final_slug <- stringr::str_extract(github_url, '(?<=git://github\\.).+?(?=\\.git)')
    return(final_slug)
  } else {
    return(NA)
  }
}

testthat::expect_equal(parse_github_slug('github.com/bi-sdal/sdalr'), 'bi-sdal/sdalr')
testthat::expect_true(is.na(parse_github_slug('yahoo.com')))
testthat::expect_true(is.na(parse_github_slug(NA)))
testthat::expect_equal(parse_github_slug('https://github.com/usnationalarchives/AVI-MetaEdit/tree/master/Release'),
                       'usnationalarchives/AVI-MetaEdit')
testthat::expect_equal(parse_github_slug('https://github.com/usgin/ContentModelCMS'), 'usgin/ContentModelCMS')
testthat::expect_equal(parse_github_slug('https://github.com/bi-sdal/sdalr.git'), 'bi-sdal/sdalr')
testthat::expect_equal(parse_github_slug('git@github.com:bi-sdal/sdalr.git'), 'bi-sdal/sdalr')
testthat::expect_equal(parse_github_slug("https://github.com/niklasvh/feedback.js"), "niklasvh/feedback.js")
testthat::expect_equal(parse_github_slug('git://github.juven14/Collapsible.git'), "juven14/Collapsible") # this url does not have github.com, just github
testthat::expect_equal(parse_github_slug('https://ternarylabs.github.io/porthole/'), "ternarylabs/porthole") # project page for repo
testthat::expect_equal(parse_github_slug('https://ternarylabs.github.io/porthole'), "ternarylabs/porthole")
