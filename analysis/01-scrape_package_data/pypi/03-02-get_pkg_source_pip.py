"""
Useage:

python analysis/01-scrape_package_data/pypi/03-02-get_pkg_source_pip.py
python analysis/01-scrape_package_data/pypi/03-02-get_pkg_source_pip.py 0
python analysis/01-scrape_package_data/pypi/03-02-get_pkg_source_pip.py 9
python analysis/01-scrape_package_data/pypi/03-02-get_pkg_source_pip.py r
"""
import sys
import os

import pandas as pd

# user passes in a number from 0-9 that represents one of the the 10 machines that will be running this code in parallel
# user can also pass in 'r' to reverse the dataset and download packages backwards
# i'm assuming this code will be either run by 1 instance, or by 10
if len(sys.argv) == 2: # if number or 'r' is passed
    if str(sys.argv[1]) == 'r': # this is a flag to referse the list
        parallel_machine_number = 'r'
    else: # I am not checking if you put in any value other than 0-9
        parallel_machine_number = int(sys.argv[1])
    print(type(parallel_machine_number))
    print(parallel_machine_number)
elif len(sys.argv) == 1: # if no value was passed (the script is always the first element in the argv)
    parallel_machine_number = -1
else: # something I didn't account for
    raise ValueError('Number of arguments was not 1 (onyl the script) or 2 (script + parallel number)')

no_prod = pd.read_pickle('./data/oss2/processed/working/pypi/non_production_ready_pip_download.pickle')[['name', 'pip_dl_cmd', 'pip_dl_d']]

# reverse the dataframe if user passed in 'r'
if parallel_machine_number == 'r':
    no_prod = no_prod.reindex(index=no_prod.index[::-1])

for idx, cmd in enumerate(no_prod['pip_dl_cmd']):
    if os.path.exists(no_prod['pip_dl_d'].iloc[idx]):
        # if the file folder already exists
        print('exists: {}: {}'.format(idx, no_prod['pip_dl_d'].iloc[idx]))
        continue
    if parallel_machine_number in [-1, 'r']:
        print(idx)
        print(cmd)
        os.system(cmd)
    elif idx % 10 == parallel_machine_number: ## this is where the value 0-9 input comes in
        print(idx)
        print(cmd)
        os.system(cmd)
        #break
    else:
        continue

print('done')
