# this script downloads all files into the same directory
# the files that end in date.csv.gz are the package download logs
# the files that end in date-r.csv.gz are the R download logs

library(progress)
library(here)

# Here's an easy way to get all the URLs in R
start <- as.Date('2012-10-01')
today <- as.Date('2019-02-04')

all_days <- seq(start, today, by = 'day')

year <- as.POSIXlt(all_days)$year + 1900

# http://cran-logs.rstudio.com/2018/2018-01-04.csv.gz
# http://cran-logs.rstudio.com/2012/2012-10-01-r.csv.gz
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
urls_r <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '-r.csv.gz')
# You can then use download.file to download into a directory.

#all_urls <- c(urls, urls_r)


pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = length(urls))
pb$tick(0)
for (i in seq_along(urls)) {
  url <- urls[[i]]
  fn <- basename(url)
  fp <- paste0(here::here('./data/oss2/original/cran/logs/pkg/'), fn)
  if (!interactive()) {
    print(fp)
  }
  if (file.exists(fp)) {
    pb$tick(1)
    next
  } else {
    download.file(url = url, destfile = fp)
    pb$tick(1)
  }
}

# copy pasted block above...
pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = length(urls_r))
pb$tick(0)
for (i in seq_along(urls_r)) {
  url <- urls_r[[i]]
  fn <- basename(url)
  fp <- paste0(here::here('./data/oss2/original/cran/logs/r/'), fn)
  if (!interactive()) {
    print(fp)
  }
  if (file.exists(fp)) {
    pb$tick(1)
    next
  } else {
    download.file(url = url, destfile = fp)
    pb$tick(1)
  }
}


# If you only want to download the files you don't have, try:
# missing_days <- setdiff(all_days, tools::file_path_sans_ext(dir(), TRUE))
