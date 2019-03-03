#
#
# useage Rscript 01-03-clone_cran.R
# useage Rscript 01-03-clone_cran.R 5 1
# useage Rscript 01-03-clone_cran.R 5 4
# useage Rscript 01-03-clone_cran.R 5 0
# useage Rscript 01-03-clone_cran.R r

library(readr)
library(here)
library(git2r)
library(dplyr)

# capture cmd args

args <- commandArgs(trailingOnly = TRUE)

print(length(args))
print(args)

num_args <- length(args)
if (num_args == 1) {
  # if you only pass in 1 parameter, I am expecting r as the value
  stopifnot(any(args %in% c('r')))
  mod <- NULL
  part <- args
} else if (num_args == 2) {
  mod <- as.integer(args[[1]])
  part <- as.integer(args[[2]])
  if (mod == part) {
    stop('the mod and part are the same value')
  }
} else if (num_args == 0) {
  # nothing passed, so just work forward in sequence
  mod <- NULL
  part <- 'f'
} else {
  stop('Unknown number of argements passed')
}

# script -----

cran <- readr::read_rds(here::here('./data/oss2/processed/cran/production_osi_gh.RDS')) %>%
  dplyr::arrange(pkg_name)

## this vector was created by running this script and checking the URLs that failed
no_work <- c(
  # bad or unparsed URLs so the slug was just NA
  "https://github.com/NA.git",
  
  # repo does not exist
  "https://github.com/BacArena/BacArena.git",
  "https://github.com/braithwaite/BIOM.utils.git",
  "https://github.com/divadnojnarg/bs4Dashindex.html.git",
  "https://github.com/alecri/softwaredosresmeta.html.git",
  "https://github.com/jinghuazhao/gap.datasets.git",
  "https://github.com/stlane/gimmeTools.git",
  "https://github.com/wencke/wenckehub.io.git",
  "https://github.com/magnusmunch/gren.git",
  "https://github.com/alecri/software.git",
  "https://github.com/zedoul/jsonstat.git",
  "https://github.com/aaronolsen/software.git",
  "https://github.com/derek-corcoran-barrios/VignetteNetworkExt.html.git",
  "https://github.com/ramey/noncensus.git",
  "https://github.com/rstudio/radix.git",
  "https://github.com/datastorm-open/introduction_ramcharts.git", # maybe renamed to rAmCharts? there are other ramcharts
  "https://github.com/thirdwing/RcppDL.git",
  "https://github.com/derek-corcoran-barrios/SpatialBall.html.git",
  "https://github.com/drastega/docs.git",
  "https://github.com/aaronolsen/tutorials.git",
  "https://github.com/petolau/package.git",
  "https://github.com/mststats/#software.git", # link to software page on website
  
  # user does not even exist
  "https://github.com/jmackie4/cycleRtools.git"
)

if (part == 'r') {
  # if r is passed, reverse the dataframe
  cran <- purrr::map_df(cran, rev)
}

for (i in seq_along(cran$pkg_name)) {
  if (is.null(mod)) { # either going forward or backward
    
    ## begin copy ##
    clone_url <- cran$gh_clone_url[[i]]
    clone_pth <- cran$gh_clone_path[[i]]
    clone_pth <- here::here(clone_pth)
    # skip these, they're 404s
    if (clone_url %in% no_work) {
      print("SKIP")
      print(i)
      print(clone_url)
      #Sys.sleep(1) ## helps you see it
      next
    }
    
    if (dir.exists(clone_pth)) {
      next
    } else {
      print(i)
      print(clone_url)
      print(clone_pth)
      try({
        git2r::clone(url = clone_url, local_path = clone_pth, progress = TRUE)
      }, outFile = './clone_cran_error.txt')
    }
    # break
    ## end copy ##

  } else { # doing a modulo split
    mod_res <- i %% mod
    if (mod_res == part) {
      
      ## begin copy ##
      clone_url <- cran$gh_clone_url[[i]]
      clone_pth <- cran$gh_clone_path[[i]]
      clone_pth <- here::here(clone_pth)
      # skip these, they're 404s
      if (clone_url %in% no_work) {
        print("SKIP")
        print(i)
        print(clone_url)
        #Sys.sleep(1) ## helps you see it
        next
      }
      
      if (dir.exists(clone_pth)) {
        next
      } else {
        print(i)
        print(clone_url)
        print(clone_pth)
        try({
          git2r::clone(url = clone_url, local_path = clone_pth, progress = TRUE)
        }, outFile = './clone_cran_error.txt')
      }
      # break
      ## end copy ##
      
    } else {
      next
    }
  }
}


# cran[668, ] %>% dplyr::select(pkg_name, url, gh_slug, gh_clone_url)
