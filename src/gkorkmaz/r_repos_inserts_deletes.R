setwd("/home/aschroed/git/oss2")
source("R/github_repo_stats.R")

result <- repo_inserts_deletes("/mnt/volume_nyc1_01/cloned_repos/cran", test_limit = 0)
write.csv(result, "src/gkorkmaz/r_repos_inserts_deletes.csv", row.names = FALSE)
