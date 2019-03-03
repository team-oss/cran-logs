library(readr)
library(here)
library(git2r)
library(dplyr)

args <- commandArgs()

pypi <- readr::read_rds(here::here('./data/oss2/processed/pypi/prod_osi_gh.RDS'))

## this vector was created by running this script and checking the URLs that failed
no_work <- c(
  # repo does not exist
  "https://github.com/saucelabs/ak_isign.git",
  "https://github.com/jinzha098718/alphalens.git",
  "https://github.com/nuta/azcat.git",
  "https://github.com/baka-framework/baka_armor.git",
  "https://github.com/renaud/checktype.git",
  "https://github.com/kinkerl/classifiers-digest.git",
  "https://github.com/opencobra/cobrapy_bigg_client.git", ## renamed with dashes
  "https://github.com/collective/collective.indexing.git",
  "https://github.com/DennyZhang/devopsprecheck.git",
  "https://github.com/pombredanne/django-guardian.git", ## fork from zulip/django-guardian (probably renamed to django-guardian-1)
  "https://github.com/vikingco/django-historicalrecords.git",
  "https://github.com/lucavandro/djangoimagepreview.git",
  "https://github.com/praekelt/django-new-preferences.git", ## maybe renamed to django-preferences?
  "https://github.com/dopstar/feed-simulator.git",
  "https://github.com//.git", ## from filabel-kuzmoyev where home_page was just github.com
  "https://github.com/fervid/.git", # helga-flip but does not exist
  "https://github.com/KKawamura1/html_writer.git", # possibly renamed to html-writer (dash)
  "https://github.com/jacentio/python-jacent-nspkg.git",
  "https://github.com/broadinstitute/m2aligner.git",
  "https://github.com/kislyuk/jaml.git",
  "https://github.com/miyadaiku/.git", # mintty-colors clone url seems wrong, but repo does not exist either
  "https://github.com/Mojob/mj-push-notification.git",
  "https://github.com/ongair/ongair-whatsapp.git", # probably renamed to just whatsapp
  "https://github.com/polyaxon/plutus.git",
  "https://github.com/fervid/helga-fliphelga-flip.git",
  "https://github.com/miyadaiku/mintty-colorsmintty-colors.git",
  "https://github.com/pyblosxom/pyauto.secretpyauto.secret.git",
  "https://github.com/DrTexxOfficial/qwerty.git",
  "https://github.com/radical-cybertools/quick-connectquick-connect.git",
  "https://github.com/dralshehri/sa-id-validator.git", # might be renamed to saudi-id-validator
  "https://github.com/lilleengen/sbanken.git", # maybe renamed sbaken-python?
  "https://github.com/nbrochu/selenium-respectful.git",
  "https://github.com/FabriceSalvaire/SimpleMorphoMath.git", # renamed simple-morpho-math?
  "https://github.com/nrocco/smeterd_exporter.git", # smetered, no smetered_exporter
  "https://github.com/rtaubes/spcc.git",
  "https://github.com/toddjames/statsd-tags.git",
  
  # user does not exist
  "https://github.com/sentineldesign/python-gowalla.git",
  "https://github.com/python-mechanize3/mechanize3.git",
  "https://github.com/alyssa.barela/pytest-unmarked.git",
  "https://github.com/tddv/sphinx_hand_theme.git",
  "https://github.com/TuneLab/tune-reporting-python.git"
)

total = length(pypi$name_pypi)

for (i in seq_along(pypi$name_pypi)) {
  clone_url <- pypi$gh_clone_url[[i]]
  clone_pth <- pypi$gh_clone_path[[i]]
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
    print(sprintf('%s / %s', i, total))
    print(clone_url)
    print(clone_pth)
    try({
      git2r::clone(url = clone_url, local_path = clone_pth, progress = TRUE)
    }, outFile = here::here('./clone_pypi_error.txt'))
  }
  # break
}


# pypi[352, ] %>% dplyr::select(name, home_page, gh_slug, gh_clone_url)
