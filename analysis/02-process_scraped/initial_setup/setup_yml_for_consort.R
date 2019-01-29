# used to add package count values for the final consort diagram
f <- './data/oss2/processed/pkg_counts/pkg_counts.yml'
if (!file.exists(f)) {file.create(f)}

empty_yaml <- list(
  cran = list(
    start = list(
      value = '',
      from = ''
    ),
    production_ready = list(
      value = '',
      from = ''
    ),
    osi = list(
      value = '',
      from = ''
    )
  ),
  python = list(
    start = list(
      value = '',
      from = ''
    ),
    production_ready = list(
      value = '',
      from = ''
    ),
    osi = list(
      value = '',
      from = ''
    )
  ),
  js = list(
    start = list(
      value = '',
      from = ''
    ),
    production_ready = list(
      value = '',
      from = ''
    ),
    osi = list(
      value = '',
      from = ''
    )
  ),
  julia = list(
    start = list(
      value = '',
      from = ''
    ),
    production_ready = list(
      value = '',
      from = ''
    ),
    osi = list(
      value = '',
      from = ''
    )
  ),
  codegov = list(
    start = list(
      value = '',
      from = ''
    ),
    production_ready = list(
      value = '',
      from = ''
    ),
    osi = list(
      value = '',
      from = ''
    )
  )
)

empty_yaml

yaml::write_yaml(empty_yaml, file = f)
