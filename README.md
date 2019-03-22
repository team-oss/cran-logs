OSS2
================

-   [Comments about this README document](#comments-about-this-readme-document)
-   [CRAN Logs](#cran-logs)
-   [Lines of Code Analysis](#lines-of-code-analysis)
    -   [Package Counts](#package-counts)
    -   [R (CRAN)](#r-cran)
    -   [Python (PyPI)](#python-pypi)
    -   [JavaScript (CDN)](#javascript-cdn)
    -   [Julia](#julia)

The code for pulling the data used in the OSS project/paper to measure the cost of open-source software by looking at lines of code

###### Comments about this README document

**DO NOT** edit the `README.md` file directly, it is generated from the `./docs/README/README.Rmd` file by running

``` bash
make readme
```

If you use a version of R &lt; 3.5 (i.e., 3.4), you will see the back slash `\` before the underscores `_` in the rendered `html` tables. Please see this related issue: <https://github.com/haozhu233/kableExtra/issues/186>. However you'll still see the `\` before the underscores in the final markdown output (see issue: )

CRAN Logs
=========

Script that downloaded the daily package download logs and daily r-base download logs from the rstudio CRAN mirror: `./analysis/01-scrape_package_data/cran/logs`

This script dumps out the r and package logs in the following folders:

-   package: `'./data/oss2/original/cran/logs/pkg/'`
-   r-base: `'./data/oss2/original/cran/logs/r/'`

Lines of Code Analysis
======================

In general, the scripts under `Getting Data` are making API calls, and running them may take a long time (or may not work depending on API changes). Code that parses downloaded data are in the `Processing Data` section. Github `clones` are under the `Github` section.

### Package Counts

Data for the table and figures come from `./docs/package_counts/package_counts.Rmd`. **DO NOT** edit the `.dot` file in `./docs/package_counts/package_count.dot`, it is generated from the `.Rmd` document.

If these numbers are not updating after making changes to `package_counts.Rmd`, try running:

``` bash
make package_counts
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Variable
</th>
<th style="text-align:right;">
CRAN
</th>
<th style="text-align:right;">
PyPI
</th>
<th style="text-align:left;">
Julia
</th>
<th style="text-align:left;">
CDN
</th>
<th style="text-align:right;">
cran+pypi
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Total
</td>
<td style="text-align:right;">
13719
</td>
<td style="text-align:right;">
165738
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
179457
</td>
</tr>
<tr>
<td style="text-align:left;">
Production Ready
</td>
<td style="text-align:right;">
13350
</td>
<td style="text-align:right;">
17482
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
30832
</td>
</tr>
<tr>
<td style="text-align:left;">
OSI Approved License
</td>
<td style="text-align:right;">
13504
</td>
<td style="text-align:right;">
30909
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
44413
</td>
</tr>
<tr>
<td style="text-align:left;">
Prod + OSI
</td>
<td style="text-align:right;">
13143
</td>
<td style="text-align:right;">
15043
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
28186
</td>
</tr>
<tr>
<td style="text-align:left;">
Prod + OSI + Github
</td>
<td style="text-align:right;">
4407
</td>
<td style="text-align:right;">
11016
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
15423
</td>
</tr>
<tr>
<td style="text-align:left;">
Cloned
</td>
<td style="text-align:right;">
4386
</td>
<td style="text-align:right;">
10609
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
14995
</td>
</tr>
<tr>
<td style="text-align:left;">
Net LOC Analysis
</td>
<td style="text-align:right;">
</td>
<td style="text-align:right;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
Gross LOC git analysis
</td>
<td style="text-align:right;">
</td>
<td style="text-align:right;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:right;">
0
</td>
</tr>
</tbody>
</table>
![](/home/chend/git/oss2/README_files/figure-markdown_github/unnamed-chunk-3-1.png)

### R (CRAN)

Running order

1.  Getting Data: `./analysis/01-scrape_package_data/cran/cran_data/`
2.  Processing Data: `./analysis/02-process_scraped/cran/`
3.  Github: `./analysis/03-github/`

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
Git Analysis
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
01-get\_cran\_packages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Reads and saves the HTML from the CRAN website: '<https://cran.r-project.org/web/packages/available_packages_by_name.html>'. This file automatically saves the date the script was run in the output file.
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-get\_pkg\_names.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Gets the URLs for each CRAN package page. Sets up the dataset for package name, package page URL, and package page download location.
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
02-download\_cran\_pkg\_pages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Downloads the package page HTML as specified by the url and save output in the input file.
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
02-get\_cran\_check\_links.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Similar to the 01-get\_pkg\_name.R script, but this gets the URL for the CRAN checks page for all the packages.
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
03-get\_cran\_chk\_pages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Downloads the package page HTML as specified by the url and save output in the input file.
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
03-parse\_cran\_check\_results.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Used the same heuristics used in the summer to determine “production ready”. There are different systems each package is checked against. We use the ones that are “release” versions to check whether a package is “production ready”. From there we look at the build status of the package for the releases. A package is marked as “production ready” if all the values are either “OK”, “NOTE”, or “WARN”. That means a package is marked as “not production ready” if any of the values are “ERROR”, or “FAIL”.
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
04-prase\_cran\_licenses.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Extracts the text from the “License: ” portion of the CRAN package page
</td>
</tr>
<tr>
<td style="text-align:right;">
8
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
04-filter\_osi\_licenses.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Uses the master osi license file to tag osi approved licenses. There is a visual check here, but it seems that those packages that are not OSI approved are CC and ACM “licenses”.
</td>
</tr>
<tr>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
05-prod\_osi.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Combines the production-ready data with the osi-approved data and then filter down packages that are both production-ready and osi-approved.
</td>
</tr>
<tr>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
06-parse\_github\_url.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Uses the link(s) provided by the “URL” value on the CRAN package page to potentially parse a github URL. If multiple github-like URLs are provided, we use the first one listed. If no github URLs are found in the “URL” section, we use look at the “Bugreport” value on the CRAN package page. If there is a github URL there we use that as the github URL to get a github user/repo slug. We use thig slug to create a clone URL to clone (i.e., download) the cran package from github.
</td>
</tr>
<tr>
<td style="text-align:right;">
11
</td>
<td style="text-align:left;">
01-get\_cran\_pkg\_src.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Extracts the text from the “package source” portion of the CRAN package page to create a download URL for the current package source compressed file.
</td>
</tr>
<tr>
<td style="text-align:right;">
12
</td>
<td style="text-align:left;">
02-download\_cran\_pkg\_src.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Downloads the files from the data specified in the input data.
</td>
</tr>
<tr>
<td style="text-align:right;">
13
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-03-clone\_cran.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Clones the github projects from the parsed github slug (user/repo). Not all slugs were valid (i.e., not all github clone urls were valid). This is because some repositories do not exist anymore, they could've been renamed, and sometimes the user (i.e., owner) does not exist anymore.
</td>
</tr>
</tbody>
</table>
<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
01-get\_cran\_packages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/original/cran/2019-02-16-cran-pkgs.html'
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-get\_pkg\_names.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/original/cran/2019-02-16-cran-pkgs.html'
</td>
<td style="text-align:left;">
./data/oss2/processed/pkg\_links.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
02-download\_cran\_pkg\_pages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/pkg\_links.csv'
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
02-get\_cran\_check\_links.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/pkg\_links.csv'
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_pkg\_chk.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
03-get\_cran\_chk\_pages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_pkg\_chk.RDS'
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
03-parse\_cran\_check\_results.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_pkg\_chk.RDS'
</td>
<td style="text-align:left;">
'./data/oss2/processed/cran/cran\_prod\_rdy.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
04-prase\_cran\_licenses.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/pkg\_links.csv'
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_meta\_licenses\_raw.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
8
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
04-filter\_osi\_licenses.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_meta\_licenses\_raw.RDS', './data/oss2/original/osi\_licenses\_all\_projects.csv'
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_osi\_licenses.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
05-prod\_osi.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_prod\_rdy.csv', './data/oss2/processed/cran/cran\_osi\_licenses.RDS'
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/production\_ready\_osi\_approved.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
06-parse\_github\_url.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/production\_ready\_osi\_approved.RDS'
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/production\_osi\_gh.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
11
</td>
<td style="text-align:left;">
01-get\_cran\_pkg\_src.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/pkg\_links.csv'
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_src\_pkg\_dl\_links.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
12
</td>
<td style="text-align:left;">
02-download\_cran\_pkg\_src.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/cran\_src\_pkg\_dl\_links.csv'
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:right;">
13
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-03-clone\_cran.R
</td>
<td style="text-align:left;">
./data/oss2/processed/cran/production\_osi\_gh.RDS'
</td>
<td style="text-align:left;">
</td>
</tr>
</tbody>
</table>
### Python (PyPI)

Running order

1.  Getting Data: `./analysis/01-scrape_package_data/pypi/`
2.  Processing Data: `./analysis/02-process_scraped/pypi/`
3.  Github: `./analysis/03-github/`

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
Git Analysis
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
01-pypi\_simple\_packages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
02-pypi\_simple\_latest\_src\_dl\_url.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
03-01-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
03-02-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
03-03-parse\_production\_ready.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
04-second\_pass\_production\_ready.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
05-01-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
05-02-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
05-03-noprod-parse\_production\_ready.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
06-combine\_fpass\_noprod.py
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
07-01-parse\_librariesio\_licenses.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
07-02-osi\_approved.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
08-combine\_before\_gh.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-04-clone\_pypi.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Clones the github projects from the parsed github slug (user/repo). Not all slugs were valid (i.e., not all github clone urls were valid). This is because some repositories do not exist anymore, they could've been renamed, and sometimes the user (i.e., owner) does not exist anymore.
</td>
</tr>
</tbody>
</table>
<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
01-pypi\_simple\_packages.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/original/pypi/pypi\_simple/2019-01-23-pypi\_simple.html',
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
02-pypi\_simple\_latest\_src\_dl\_url.R
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
03-01-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
03-02-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
03-03-parse\_production\_ready.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
04-second\_pass\_production\_ready.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
./data/oss2/processed/working/pypi/non\_production\_ready\_pip\_download.pickle'
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:right;">
11
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
05-01-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
05-02-noprod-downloaded\_src\_simple\_metadata.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
05-03-noprod-parse\_production\_ready.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
06-combine\_fpass\_noprod.py
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
07-01-parse\_librariesio\_licenses.R
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
07-02-osi\_approved.R
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
08-combine\_before\_gh.R
</td>
<td style="text-align:left;">
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
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-04-clone\_pypi.R
</td>
<td style="text-align:left;">
./data/oss2/processed/pypi/prod\_osi\_gh.RDS'
</td>
<td style="text-align:left;">
</td>
</tr>
</tbody>
</table>
### JavaScript (CDN)

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
Git Analysis
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
01-get\_pkg\_json\_info.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Gets all the libraries listed from cdn.js using the API. Saves the GET response as a json file
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-cdn\_pkg\_info.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Converts the JSON response into a dataframe. Takes the first listed license for each package, and looks into the (older) license file to see if a package has an OSI approved license.

The license file used to determine whether a package is an OSI approved package uses an older license file used from Summer 2018. If you are re-doing this analysis, you should use the one stated in the script as a comment. The license file generated from './analysis/osi\_licenses/create\_master\_osi\_approved.R'. This is the same license file used for the CRAN and PyPI analysis. Any “missing” licenses should be programmatically added using that script.
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
02-filter\_osi.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Uses the older license dataset to filter packages that were OSI approved. Please see note(s) above about the “older” license file.

This script filters cdn libraries where osi\_approved is TRUE.
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
03-github\_slugs.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Uses the repository.url value to parse the github slug
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-clone\_gh\_repos.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
This script is the same script used in the Julia analysis to download the github repositories. See the notes in the Julia script for more information.

Essentially this script clones the cdn repositories that have a github url into a specified directory
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
travis.R
</td>
<td style="text-align:left;">
The students over the Summer 2018 skipped all checks for “production ready” and assumed that all packages were already production ready. There is no standarized way to look for production ready packages in CDN when this analysis was done. One thought was to look at the Travis status for the github packages (like what we did for Julia). This script aimes to get information using travis. But we abandoned this because so many of the packages were lost because they did not use Travis for CI. This is why cdn was also dropped from the LOC analysis.
</td>
</tr>
</tbody>
</table>
<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
01-get\_pkg\_json\_info.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./data/oss2/original/cdn/libraries\_json/'
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-cdn\_pkg\_info.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./data/oss2/original/cdn/libraries\_json/', './data/oss/final/PyPI/osi\_approved\_licenses.csv'
</td>
<td style="text-align:left;">
'./data/oss2/processed/cdn/cdn\_with\_license.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
02-filter\_osi.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./data/oss2/processed/cdn/cdn\_with\_license.csv', './data/oss/final/PyPI/osi\_approved\_licenses.csv'
</td>
<td style="text-align:left;">
'./data/oss2/processed/cdn/cdn\_osi.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
03-github\_slugs.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./data/oss2/processed/cdn/cdn\_osi.csv'
</td>
<td style="text-align:left;">
'./data/oss2/processed/cdn/cdn\_gh\_slugs.csv'
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-clone\_gh\_repos.R
</td>
<td style="text-align:left;">
'./data/oss2/processed/cdn/cdn\_gh\_slugs.csv'
</td>
<td style="text-align:left;">
'./data/oss2/original/cloned\_repos/cdn/'
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./data/oss2/original/cloned\_repos/cdn'
</td>
<td style="text-align:left;">
</td>
</tr>
</tbody>
</table>
### Julia

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
Git Analysis
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
JuliaEcosystem/src/JuliaEcosystem.jl
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
From Bayoan, creates a dataset for each julia package, the version of the package, and its (Github) repository URL along with all of that package’s dependencies. You need to run this script from the base JuliaEscosystem directory, not the R project directory.
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-julia\_ecosystem.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Counts the number of unique julia packages
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-clone\_gh\_repos.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
This script downloads the Julia and CDN git repositories. In an ideal world, this script would’ve downloaded all the github repositories for all the languages in the project, But towards the end of the project, it was easier to have separate clone scripts for CRAN and PyPI. There are functions in this script that could be expanded to work with the cran and pypi repositories that would then be moved into the R folder.

Having said that, the relevant part of this script creates the github slug from the julia repositories and then clones the repositories into a specified directory
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-travis\_build\_status.R
</td>
<td style="text-align:left;">
Used the github slug to query the Travis API to get the build status of the master branch from Travis. This was used to determine whether or not a package was “production ready”
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
01-get\_licensee.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Runs the licensee command (from npm) to get the license for each of the Julia package LICENSE files.
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
02-parse\_licensee.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Parses the text from Licensee to get OSI approved licenses. We stopped the analysis for Julia here because the vast majority of liceses were not able to be detected by Licensee (thus, also on Github). We get a “License: NOASSERTION” response from licensee. Most of the licenses are OSI approved, but because the text of the license file was altered, licensee was unable to assign the correct license to the repository. We end up with only 418 OSI approved licenses, which is incorrect.

We used licensee here because it is the same program/software Github uses to determine what license a repository is using. Spot checking the NOASSERTION results on Github also show no license tagged in the repository. Because trying to write a heuristic to “fix” licensee would mean “doing better than Github” we opted not to include Julia for the LOC analysis so far.

One way might be to do a simple string match on the license file (e.g., does the string MIT exist in this file? Or does MIT exist as a word in this file).

This script is not very “clean” it has a lot of exploratory work in it. Since we were still trying to figure out how to continue with the Julia ecosystem.
</td>
</tr>
</tbody>
</table>
<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
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
JuliaEcosystem/src/JuliaEcosystem.jl
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Manifest.toml, Project.toml
</td>
<td style="text-align:left;">
./analysis/01-scrape\_package\_data/julia/JuliaEcosystem/data/julia.tsv
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-julia\_ecosystem.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./analysis/01-scrape\_package\_data/julia/JuliaEcosystem/data/julia.tsv'
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
01-clone\_gh\_repos.R
</td>
<td style="text-align:left;">
'./analysis/01-scrape\_package\_data/julia/JuliaEcosystem/data/julia.tsv'
</td>
<td style="text-align:left;">
'./data/oss2/original/cloned\_repos/julia/'
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./analysis/01-scrape\_package\_data/julia/JuliaEcosystem/data/julia.tsv'
</td>
<td style="text-align:left;">
'./data/oss2/processed/julia/pkg\_travis\_badge.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
01-get\_licensee.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./data/oss2/processed/julia/pkg\_travis\_badge.RDS'
</td>
<td style="text-align:left;">
'./data/oss2/processed/julia/pkg\_licensee\_detect.RDS'
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
02-parse\_licensee.R
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
'./data/oss2/processed/julia/pkg\_licensee\_detect.RDS'
</td>
<td style="text-align:left;">
</td>
</tr>
</tbody>
</table>
