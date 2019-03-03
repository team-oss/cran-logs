import pandas as pd

pd.set_option('max_colwidth', 200)

fdf = pd.read_pickle('./data/oss2/processed/working/pypi/production_ready_first_pass.pickle')

fdf['dev_status_clean'].value_counts()

# get the packages that were not initially marked as production/stable or mature
f_no_prod = fdf.loc[(fdf['dev_status_clean'] != 'production/stable') & (fdf['dev_status_clean'] != 'mature')]
f_no_prod['dev_status_clean'].value_counts()

# build the string to exectue
f_no_prod['pip_dl_d'] = "./data/oss2/original/pypi/pypi_simple/simple_pkg_src_pip_dl/" + f_no_prod['name_pypi']
f_no_prod['pip_dl_cmd'] = "pip download -d " + f_no_prod['pip_dl_d'] + " --no-deps " + f_no_prod['name_pypi']

print(f_no_prod['pip_dl_d'].head())
print(f_no_prod['pip_dl_cmd'].head())

f_no_prod.to_pickle('./data/oss2/processed/working/pypi/non_production_ready_pip_download.pickle')
f_no_prod.to_csv('./data/oss2/processed/working/pypi/non_production_ready_pip_download.csv', index = False)

print('done.')

## this was the file name used by 03-03-parse_production_ready
## that saved the production/stable mature ready packages
#df.to_pickle('./data/oss2/processed/working/pypi/production_ready.pickle')
#df.to_csv('./data/oss2/processed/working/pypi/production_ready.csv', index=False)
