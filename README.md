Untitled
================

-   [CRAN Logs](#cran-logs)
-   [Lines of Code Analysis](#lines-of-code-analysis)
    -   [R (CRAN)](#r-cran)
    -   [Python (PyPI)](#python-pypi)
    -   [JavaScript (CDN)](#javascript-cdn)
    -   [Julia](#julia)

CRAN Logs
=========

Script that downloaded the daily package download logs and daily r-base download logs from the rstudio CRAN mirror: `./analysis/01-scrape_package_data/cran/logs`

-   package: `'./data/oss2/original/cran/logs/pkg/'`
-   r-base: `'./data/oss2/original/cran/logs/r/'`

Lines of Code Analysis
======================

In general, the scripts under `Getting Data` are making API calls, and running them may take a long time (or may not work depending on API changes).

### R (CRAN)

### Python (PyPI)

Running order

1.  Getting Data: `./analysis/01-scrape_package_data/pypi/`
2.  Processing Data: `./analysis/02-process_scraped/pypi/`

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
run\_order
</th>
<th style="text-align:left;">
Getting Data
</th>
<th style="text-align:left;">
Processing Data
</th>
<th style="text-align:left;">
Github
</th>
<th style="text-align:left;">
Notes
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
01-get\_pypi\_simple.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Use <http://pypi.org/simple/> to get a list of all the packages listed on pypi.
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
02-get\_pkg\_html\_simple.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
We get the URL for each of the packages listed in pypi.org/simple, and save the page to a html file that we can parse.
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
01-pypi\_simple\_packages.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Counts the number of URLS obtained by pypi.org/simple (conversly, the number of packages on PyPI) -- on January 23, 2019
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
02-pypi\_simple\_latest\_src\_dl\_url.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Takes the last package version listed in each of the package HTML pages. We capture this link in order to get the "latest" version of the package listed in pypi.org/simple.
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
03-01-get\_pkg\_source\_simple.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
The dataset from `02-pypi_simple_latest_src_dl_url.R` only returns the URL to download the package, this script then goes through each of the URLs and saves it into the corresponding download location (which is found in the dataset).
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
03-01-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
the `03-xx` series of script all process the metadata from the downloaded package source files. We first use the python `pkginfo` package to introspect each of the downloaded packages. We accounted for `.whl`, `.gz`, `.zip`, `.egg`, `.bz2`, and `.tgz` extensions. The corresponding function within pkginfo is used for each of the various file extensions, and we save the reponse to a column in our dataset. This script takes a long time to run (~20-30 minutes), that is why these steps are broken up into multiple parts. This script only saves the reponse from `pkginfo` into a column. These python scripts save out data in both `csv` and `pickle` formats, the `csv` is really there as a convenience, but all the binary information will be lost. The `pickle` format is what is actually used between scripts.
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
03-02-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Information about each package is stored in a python object (from pkginfo). Here we take all the object attributes (stored as a Python dictionary) and converrt it into a dataframe object. We may not have gotten every bit of information stored in the object, but it captures all the information we want in this project. There is a renaming of the "name" variable to "name\_pypi" here, since one of the attributes is also called "name". It's important here that you use the "name\_pypi" as the primary key moving forward, since the "name" from the attribute does not always match what was captured from PyPI.
</td>
</tr>
<tr>
<td style="text-align:right;">
8
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
03-03-parse\_production\_ready.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Development status is captured by the classifier variable, which stores a list of strings of various other "classifications" for the package. Here we extract/parse out the development status string from the classifier variable. The goal is to perform an analysis on "production/stable" and "mature" packages.
</td>
</tr>
<tr>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
04-second\_pass\_production\_ready.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Since we looked at the "latest" source file when we were getting information from pypi.org/simple, not all packages that were "production ready" were marked as such. For example, the source file we downloaded for `pandas` was an alpha release, but we know it is a "production ready" package Takes the packages that were not already marked as production/stable or mature, and builds the pip download command to download source packages directly from pip.
</td>
</tr>
<tr>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
03-02-get\_pkg\_source\_pip.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Runs the pip download command to download the latest pip installable package source. This was to capture package sources downloaded from 03-01 that were potentially alpha or other "non production ready" releases. If the analysis were to be redone, we would use this method directly (i.e., use pip download instead of manually downloading the "latest" source). This means that `03-01-get_pkg_source_simple.R` to `03-03-parse_production_ready.py` would not need to be run, and we would capture the pip downloads directly.
</td>
</tr>
<tr>
<td style="text-align:right;">
11
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
05-01-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
these scripts all follow the same process as the 03-0x counterparts. Since the code and functions were not setup to be a python module, any changes in the 05-0x set of scripts need to be manually changed in the 03-0x set of scripts, or vice versa.

This script introspects the downloaded sources (this time form pip download) and extracts the pkginfo.
</td>
</tr>
<tr>
<td style="text-align:right;">
12
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
05-02-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Take the object from pkginfo and pivot the attributes to a dataframe
</td>
</tr>
<tr>
<td style="text-align:right;">
13
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
05-03-noprod-parse\_production\_ready.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Clean up the development status from the classifier variable
</td>
</tr>
<tr>
<td style="text-align:right;">
14
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
06-combine\_fpass\_noprod.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Since we collected "production ready" packages in multiple ways, this script combines the datasets so we have a single dataset we can use to filter "production ready" status. We filter out dataset here for those packages that are "production/stable" and "mature" as defined by the deveopment status from the classifier variable.
</td>
</tr>
<tr>
<td style="text-align:right;">
15
</td>
<td style="text-align:left;">
04-licenses.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Make sure you have the LIBRARIES\_IO\_API\_KEY defined in your r environment.

Takes the "production ready" packages and uses the libraries.io API to get more infomration from the each package. We are just saving the API REST GET reponse here that will be parsed in the next step. Because the license field of the metadata from pkginfo is all user reported, there are 7000+ unique values put in for license. We use libraries.io here to get a more standardized list of licenses.
</td>
</tr>
<tr>
<td style="text-align:right;">
16
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
07-01-parse\_librariesio\_licenses.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Parse the GET response from libraries.io to get the 'normalized\_licenses' value. Some packages have multiple licenses listed (some have up to 4). The first license was used as the license from libraries.io (saved as the column `l`)
</td>
</tr>
<tr>
<td style="text-align:right;">
17
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
07-02-osi\_approved.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
There is a master list of OSI approved licenses that is used in this step. It helps keep track of all the OSI licenses and the ways they can be typed in a license field.

If there is a license missing from the libraries.io service, we fill in the missing license from the "license" pkginfo metadata. We didn't use the license from pkginfo directly, becuase all the information is user input, and there were too many unique license values to account for.

Once we have all the license infomation, we mark each package as having an OSI-approved license or not
</td>
</tr>
<tr>
<td style="text-align:right;">
18
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
08-combine\_before\_gh.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Combine the information about "production ready" status with "osi approved license" to get a final set of packages that we will use to pull from github. Once we have the production-ready-osi-approved packages, we then use `home_page` column to potentially get a Github URL, if no github url was provided in the `home_page` column, we used the `download_url` column. This was similar to looking at the URL and Bug Report information in the CRAN analysis. Some github URLs were just the username, so we created the github slug by appending the python package name to create the user/repo slug.

We end up with a dataset of github slugs (which we can use to clone information) that are production ready with OSI approved licenses
</td>
</tr>
<tr>
<td style="text-align:right;">
19
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
01-04-clone\_pypi.R
</td>
<td style="text-align:left;">
Clones the github projects from the parsed github slug (user/repo). Not all slugs were valid (i.e., not all github clone urls were valid). This is because some repositories do not exist anymore, they could've been renamed, and sometimes the user (i.e., owner) does not exist anymore.
</td>
</tr>
</tbody>
</table>
<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
run\_order
</th>
<th style="text-align:left;">
Getting Data
</th>
<th style="text-align:left;">
Processing Data
</th>
<th style="text-align:left;">
Github
</th>
<th style="text-align:left;">
input
</th>
<th style="text-align:left;">
output
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
01-get\_pypi\_simple.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/2019-01-23-pypi\_simple.html'
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
02-get\_pkg\_html\_simple.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/2019-01-23-pypi\_simple.html'
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/simple\_pkg\_htmls/'
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
01-pypi\_simple\_packages.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/2019-01-23-pypi\_simple.html',
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
02-pypi\_simple\_latest\_src\_dl\_url.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/simple\_pkg\_htmls', './data/oss2/original/pypi/pypi\_simple/2019-01-23-pypi\_simple.html'
</td>
<td style="text-align:left;">
./data/oss2/processed/pypi/simple\_url\_src\_paths.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
03-01-get\_pkg\_source\_simple.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/pypi/simple\_url\_src\_paths.csv'
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/simple\_pkg\_src/'
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
03-01-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/simple\_pkg\_src/', './data/oss2/processed/pypi/simple\_url\_src\_paths.csv'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/simple\_downloaded\_pkginfo\_attr.csv', './data/oss2/processed/working/pypi/simple\_downloaded\_pkginfo\_attr.pickle'
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
03-02-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/simple\_downloaded\_pkginfo\_attr.pickle'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/parsed\_pkg\_attributes.csv', './data/oss2/processed/working/pypi/parsed\_pkg\_attributes.pickle'
</td>
</tr>
<tr>
<td style="text-align:right;">
8
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
03-03-parse\_production\_ready.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/parsed\_pkg\_attributes.pickle'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready\_first\_pass.pickle', './data/oss2/processed/working/pypi/production\_ready\_first\_pass.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
04-second\_pass\_production\_ready.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready\_first\_pass.pickle'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/non\_production\_ready\_pip\_download.pickle', './data/oss2/processed/working/pypi/non\_production\_ready\_pip\_download.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
03-02-get\_pkg\_source\_pip.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/non\_production\_ready\_pip\_download.pickle'
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:right;">
11
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
05-01-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/non\_production\_ready\_pip\_download.pickle'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/simple\_downloaded\_pkginfo\_attr\_noprod.csv', './data/oss2/processed/working/pypi/simple\_downloaded\_pkginfo\_attr\_noprod.pickle'
</td>
</tr>
<tr>
<td style="text-align:right;">
12
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
05-02-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/simple\_downloaded\_pkginfo\_attr\_noprod.pickle'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/parsed\_pkg\_attributes\_noprod.csv', './data/oss2/processed/working/pypi/parsed\_pkg\_attributes\_noprod.pickle'
</td>
</tr>
<tr>
<td style="text-align:right;">
13
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
05-03-noprod-parse\_production\_ready.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/parsed\_pkg\_attributes\_noprod.pickle'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready\_noprod.pickle', './data/oss2/processed/working/pypi/production\_ready\_noprod.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
14
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
06-combine\_fpass\_noprod.py
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready\_noprod.pickle', './data/oss2/processed/working/pypi/production\_ready\_first\_pass.pickle'
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready.pickle', './data/oss2/processed/working/pypi/production\_ready.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
15
</td>
<td style="text-align:left;">
04-licenses.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready.csv'
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/libraries.io'
</td>
</tr>
<tr>
<td style="text-align:right;">
16
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
07-01-parse\_librariesio\_licenses.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready.csv', './data/oss2/original/pypi/libraries.io'
</td>
<td style="text-align:left;">
./data/oss2/processed/pypi/librariesio\_licenses.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
17
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
07-02-osi\_approved.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
"./data/oss2/original/osi\_licenses\_all\_projects.csv", './data/oss2/processed/pypi/librariesio\_licenses.RDS'
</td>
<td style="text-align:left;">
./data/oss2/processed/pypi/osi\_approved.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
18
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
08-combine\_before\_gh.R
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/production\_ready.csv', './data/oss2/processed/pypi/osi\_approved.RDS'
</td>
<td style="text-align:left;">
./data/oss2/processed/pypi/prod\_osi\_gh.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
19
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
01-04-clone\_pypi.R
</td>
<td style="text-align:left;">
./data/oss2/processed/pypi/prod\_osi\_gh.RDS'
</td>
<td style="text-align:left;">
NA
</td>
</tr>
</tbody>
</table>
### JavaScript (CDN)

Running order

| Getting Data              | Parsing Data        |
|---------------------------|---------------------|
| 01-get\_pkg\_json\_info.R |                     |
|                           | 01-cdn\_pkg\_info.R |

1.  `01-get_pkg_json_info.R`: download package infor from `https://api.cdnjs.com/libraries/`

-   input: None
-   output: `/data/oss2/original/cdn/libraries_json/`

-   input: `'./data/oss2/original/cdn/libraries_json/'`

### Julia
