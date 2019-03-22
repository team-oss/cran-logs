readme:
	Rscript -e "rmarkdown::render('./docs/README/README.Rmd', output_dir = '.', intermediates_dir = './docs/README/')"

package_counts:
	Rscript -e "rmarkdown::render('./docs/package_counts/package_counts.Rmd', output_dir = './docs/package_counts/', intermediates_dir = './docs/package_counts/')"
