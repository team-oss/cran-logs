source("R/github_repo_stats.R")

result <- repo_inserts_deletes("/mnt/volume_nyc1_01/cloned_repos/cran", test_limit = 100)
write.csv(result, "src/gkorkmaz/cran_inserts_deletes.csv", row.names = FALSE)
