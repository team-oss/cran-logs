library(readr)

julia <- readr::read_tsv('./analysis/01-scrape_package_data/julia/JuliaEcosystem/data/julia.tsv')

nrow(julia)

head(julia)
tail(julia)

length(unique(julia$name))

julia %>% head()

length(unique(julia$name))
