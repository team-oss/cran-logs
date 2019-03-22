readme:
	Rscript -e "rmarkdown::render('./docs/README/README.Rmd', output_dir = '.')"

package_counts:
	Rscript -e "rmarkdown::render('./docs/package_counts/package_counts.Rmd', output_dir = './docs/package_counts/')"
