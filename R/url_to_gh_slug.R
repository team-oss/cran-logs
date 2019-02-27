#' takes in a github url, returns the org/repo slug
#' @examples
#' parse_github_slug('github.com/bi-sdal/sdalr')
parse_github_slug <- function(github_url) {
  if (is.na(github_url)) {
    return(NA)
  } else if (stringr::str_detect(github_url, 'https?://.*\\.github.com/.*')) {
    # account for strings like http://dlinzer.github.com/poLCA (where usually it's github.io, not github.com)
    user <- stringr::str_extract(github_url, '(?<=https?://).*(?=\\.github\\.com)')
    repo <- stringr::str_extract(github_url, '(?<=\\.github\\.com/).*(?=/?)')
    repo <- stringr::str_remove(repo, '/')
    final_slug <- stringr::str_c(user, repo, sep = '/')
    return(final_slug)
  } else if (stringr::str_detect(github_url, 'github.com')) {
    # regex for another time, let's not throw the kitchen sink when we don't have to
    #final_slug <- stringr::str_extract(github_url, '(?<=github\\.com/).*?/.*?(?=/|#|$|\\.)')
    
    after_github <- stringr::str_split_fixed(github_url, 'github.com(/|:)', 2)[, 2]
    slug_components <- stringr::str_split_fixed(after_github, '/', 3)[, c(1, 2)]
    collapsed <- paste(slug_components, collapse = '/')
    final_slug <- stringr::str_replace(collapsed, '\\.git', '')
    final_slug <- stringr::str_replace(final_slug, '#.*', '')
    final_slug <- stringr::str_replace(final_slug, '\\s.*', '')
    return(final_slug)
  } else if (stringr::str_detect(github_url, 'github.io')) { # account for github pages urls for repositoryes
    # e.g., https://ternarylabs.github.io/porthole/,
    # e.g., http://ternarylabs.github.io/porthole/ ## note https vs http
    user <- stringr::str_extract(github_url, '(?<=https?://).*(?=\\.github\\.io)')
    repo <- stringr::str_extract(github_url, '(?<=\\.github\\.io/).*(?=/?)')
    repo <- stringr::str_remove(repo, '/')
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

# testthat::expect_equal(parse_github_slug(), )
# 
testthat::expect_true(is.na(parse_github_slug('yahoo.com')))
testthat::expect_true(is.na(parse_github_slug(NA)))

testthat::expect_equal(parse_github_slug('github.com/bi-sdal/sdalr'), 'bi-sdal/sdalr')
testthat::expect_equal(parse_github_slug('https://github.com/usnationalarchives/AVI-MetaEdit/tree/master/Release'), 'usnationalarchives/AVI-MetaEdit')
testthat::expect_equal(parse_github_slug('https://github.com/usgin/ContentModelCMS'), 'usgin/ContentModelCMS')
testthat::expect_equal(parse_github_slug('https://github.com/bi-sdal/sdalr.git'), 'bi-sdal/sdalr')
testthat::expect_equal(parse_github_slug("https://github.com/niklasvh/feedback.js"), "niklasvh/feedback.js")
testthat::expect_equal(parse_github_slug('https://github.com/HSU-ANT/ACME.jl'), 'HSU-ANT/ACME.jl')
testthat::expect_equal(parse_github_slug('https://github.com/google/brotli#readme (upstream)'), 'google/brotli')

testthat::expect_equal(parse_github_slug('https://ternarylabs.github.io/porthole/'), "ternarylabs/porthole") # project page for repo
testthat::expect_equal(parse_github_slug('https://ternarylabs.github.io/porthole'), "ternarylabs/porthole")

testthat::expect_equal(parse_github_slug('git@github.com:bi-sdal/sdalr.git'), 'bi-sdal/sdalr')
testthat::expect_equal(parse_github_slug('git://github.juven14/Collapsible.git'), "juven14/Collapsible") # this url does not have github.com, just github

testthat::expect_equal(parse_github_slug('http://marcinkosinski.github.io/archivist.github/'), "marcinkosinski/archivist.github")
testthat::expect_equal(parse_github_slug("http://dlinzer.github.com/poLCA"), "dlinzer/poLCA")

#' Takes a string that contains multiple URLs, and returns a single github slug
multiple_url_parse_gh_slug <- function(url_string, num_urls=NULL, url_delim_pattern = ',\\n|,|\\n') {
  if (is.null(num_urls)) {
    num_urls <- count_urls(url_string)
  }
  if (num_urls == 1) {
    return(parse_github_slug(url_string))
  } else if (num_urls > 1) {
    # if there are more than 1 urls, count the number of urls with github in it
    num_gh <- stringr::str_count(url_string, 'github')
    
    if (num_gh == 1) { ## if there is only 1 with github, just take that one
      # break up the string into the parts
      url_v <- stringr::str_split(url_string, url_delim_pattern)[[1]]
      
      # find the gh url
      url_gh <- stringr::str_detect(url_v, 'github')
      url_gh <- url_v[url_gh]
      
      # return it
      stopifnot(length(url_gh) == 1)
      return(parse_github_slug(url_gh))
    } else if (num_gh > 1) { ## if there are more than 1 github urls, take the first one?
      url_v <- stringr::str_split(url_string, url_delim_pattern)[[1]]
      url_gh <- stringr::str_detect(url_v, 'github')
      ## get the first match here
      url_gh <- url_v[url_gh][[1]]
      return(parse_github_slug(url_gh))
    } else {
      warning('num_gh < 1')
      return(NA)
    }
  } else {
    warning('num_urls < 1')
    return(NA)
  }
}

testthat::expect_equal(multiple_url_parse_gh_slug("https://declaredesign.org/r/fabricatr,\nhttps://github.com/DeclareDesign/fabricatr", 2), "DeclareDesign/fabricatr")
testthat::expect_equal(multiple_url_parse_gh_slug("https://github.com/objornstad/epimdr,\nhttps://www.springer.com/gp/book/9783319974866,\nhttp://ento.psu.edu/directory/onb1"), "objornstad/epimdr")
testthat::expect_equal(multiple_url_parse_gh_slug("https://github.com/jolars/eulerr, https://jolars.github.io/eulerr/"), "jolars/eulerr")
testthat::expect_equal(multiple_url_parse_gh_slug("https://github.com/ropensci/cld2 (devel)\nhttps://github.com/cld2owners/cld2 (upstream)"), "ropensci/cld2")
testthat::expect_equal(multiple_url_parse_gh_slug("http://www.bifie.at,\nhttps://www.bifie.at/bildungsforschung/forschungsdatenbibliothek,\nhttps://www.bifie.at/large-scale-assessment-mit-r-methodische-grundlagen-der-oesterreichischen-bildungsstandardueberpruefung,\nhttps://github.com/alexanderrobitzsch/BIFIEsurvey,\nhttps://sites.google.com/site/alexanderrobitzsch2/software"), "alexanderrobitzsch/BIFIEsurvey")
testthat::expect_equal(multiple_url_parse_gh_slug("http://github.com/ajaygpb/ammistability\nhttps://CRAN.R-project.org/package=ammistability\nhttps://ajaygpb.github.io/ammistability\nhttps://doi.org/10.5281/zenodo.1344756"), "ajaygpb/ammistability")
testthat::expect_equal(multiple_url_parse_gh_slug('https://github.com/boxuancui/DataExplorer', 1), 'boxuancui/DataExplorer')


# testthat::expect_equal(multiple_url_parse_gh_slug(), )
