
# CRAN Logs

Script that downloaded the daily package download logs and daily r-base download logs from the rstudio CRAN mirror:
`./analysis/01-scrape_package_data/cran/logs`

- package: `'./data/oss2/original/cran/logs/pkg/'`
- r-base: `'./data/oss2/original/cran/logs/r/'`

# Lines of Code Analysis

In general, the scripts under `Getting Data` are making API calls,
and running them may take a long time (or may not work depending on API changes).

### R (CRAN)

### Python (PyPI)

Running order

| Getting Data               	| Processing Data                           |
|----------------------------	|-----------------------------------------	|
| 01-get_pypi_simple.R       	|                                         	|
| 02-get_pkg_html_simple.R   	|                                         	|
|                            	| 01-pypi_simple_packages.R               	|
|                            	| 02-pypi_simple_latest_src_dl_url.R      	|
| 03-get_pkg_source_simple.R 	|                                         	|
|                            	| 03-01-downloaded_src_simple_metadata.py 	|
|                            	| 03-02-downloaded_src_simple_metadata.py 	|
|                            	| 03-03-parse_production_ready.py         	|
| 04-licenses.R              	|                                         	|
|                            	| 04-01-parse_librariesio_licenses.R      	|
|                            	| 04-02-osi_approved.R                    	|
|                            	| 05-combine_before_gh.R                  	|
|                            	|                                         	|
|                            	|                                         	|

**Getting Data**

1.  `01-get_pypi_simple.R`: Pulls the listed repos from pypi/simple
    - output: `'./data/oss2/original/pypi/%s-pypi_simple.html', Sys.Date()`
1.  `02-get_pkg_html_simple.R`: Get's the package pages from each of the pypi/simple package listings
    - input: `'./data/oss2/original/pypi/pypi_simple/2019-01-23-pypi_simple.html'`
    - output: `'./data/oss2/original/pypi/pypi_simple/simple_pkg_htmls/'`
1.  `03-get_pkg_source_simple.R`:
    - input: `'./data/oss2/processed/pypi/simple_url_src_paths.csv'`
    - output: as defined in input`$src_save_path`
1.  `04-licenses.R`:
    - input: `'./data/oss2/processed/working/pypi/production_ready.csv'`
    - output: as defined in input`$save_path`

**Processing Data**

2.  `01-pypi_simple_packages.R`: Counts the number of packages from PyPI
    - input: `'./data/oss2/original/pypi/2019-01-23-pypi_simple.html'`
2.  `02-pypi_simple_latest_src_dl_url.R`:
    - input: `'./data/oss2/original/pypi/pypi_simple/simple_pkg_htmls'`
    - input: `'./data/oss2/original/pypi/pypi_simple/2019-01-23-pypi_simple.html'`
    - output: `'./data/oss2/processed/pypi/simple_url_src_paths.csv'`

2.  `03-01-downloaded_src_simple_metadata.py`:
    - input: `'./data/oss2/original/pypi/pypi_simple/simple_pkg_src/'`
    - input: `'./data/oss2/processed/pypi/simple_url_src_paths.csv'`
    - output: `'./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.csv'`
    - output: `'./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.feather'`
    - output: `'./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.pickle'`
2.  `03-02-downloaded_src_simple_metadata.py`:
    - input: `'./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.pickle`
    - output: `'./data/oss2/processed/working/pypi/parsed_pkg_attributes.pickle'`

2. `03-03-parse_production_ready.py`:
    - input: `'./data/oss2/processed/working/pypi/parsed_pkg_attributes.pickle'`
    - output: `./data/oss2/processed/working/pypi/production_ready.csv'`
    - output: `'./data/oss2/processed/working/pypi/production_ready.pickle'`

2. `04-01-parse_librariesio_licenses.R`:
    - input: `'./data/oss2/processed/working/pypi/production_ready.csv'`
    - output: `'./data/oss2/processed/pypi/librariesio_licenses.RDS'`
2. `04-02-osi_approved.R`:
    - input: `"./data/oss/final/PyPI/osi_approved_licenses.csv"`
    - input: `'./data/oss2/processed/pypi/librariesio_licenses.RDS'`
    - output: `'./data/oss2/processed/pypi/osi_approved.RDS'`
2. `05-combine_before_gh.R`: Combines the OSI data from libraries.io with the production status metadata
  - input: 
  - input:
  - output:




### JavaScript (CDN)

Running order

| Getting Data               	| Parsing Data                            	|
|----------------------------	|-----------------------------------------	|
| 01-get_pkg_json_info.R     	|                                         	|
|                            	| 01-cdn_pkg_info.R                       	|

1. `01-get_pkg_json_info.R`: download package infor from `https://api.cdnjs.com/libraries/`
  - input: None
  - output: `/data/oss2/original/cdn/libraries_json/`

  - input: `'./data/oss2/original/cdn/libraries_json/'`

### Julia
