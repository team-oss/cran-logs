"""Aims to follow the same steps as 03-02 on the second pass pip download packages
These packages were initially flagged as not being production/stable or mature
because the "latest" source was downloaded initially
"""

import os
import pandas as pd
from pathlib import Path
from tarfile import ReadError # error when parsing src pkg
import pkginfo as pkg
import seaborn as sns
import re

from tqdm import tqdm
tqdm.pandas()

pd.options.display.max_colwidth = 999

def get_pkginfo(f):
    fp, ext = os.path.splitext(f)
    #print(f)
    try:
        if ext == '.whl':
            return pkg.Wheel(f)
        elif ext == '.gz':
            return pkg.SDist(f)
        elif ext == '.zip':
            return pkg.SDist(f)
        elif ext == '.egg':
            return pkg.BDist(f)
        elif ext == '.bz2':
            return pkg.SDist(f)
        elif ext == '.tgz':
            return pkg.SDist(f)
    except ReadError:
        return None
    except ValueError:
        return None
    else:
        return None


def get_pkginfo_attr(pkginfo_obj):
    attributes = [attr for attr in dir(pkginfo_obj) 
              if not attr.startswith('__')]
    return {x:pkginfo_obj.__getattribute__(x) for x in attributes}


print('Loading Data')

no_prod_dl = pd.read_pickle('./data/oss2/processed/working/pypi/non_production_ready_pip_download.pickle')


# make sure no names are duplicated,
# since it will be used as a joining key
assert any(no_prod_dl[['name_pypi']].duplicated()) == False

no_prod_dl['pip_dl_f_exists'] = no_prod_dl['pip_dl_d'].\
    apply(os.path.exists)
print(no_prod_dl.shape)

no_prod = no_prod_dl.loc[no_prod_dl['pip_dl_f_exists'] == True]
print(no_prod.shape)

no_prod['pip_dl_num_f'] = no_prod['pip_dl_d'].\
    apply(lambda x: len(os.listdir(x)))

cts = no_prod['pip_dl_num_f'].value_counts()
print(cts)

# make sure the counts are just 0, or 1
assert cts.index.isin([1, 0]).all()

# see if package source was downloaded
no_prod['pip_dl_status'] = no_prod['pip_dl_num_f'] == 1

print(no_prod['pip_dl_status'].value_counts(dropna=False))

# only work on subset of data where packages were downloaded
# this starts to follow the script in 03-01 now
downloaded = no_prod.loc[no_prod['pip_dl_status'] == True]

print('Build src_save_path per 03-01 script')

downloaded['src_save_path'] = downloaded['pip_dl_d'].apply(os.listdir)
downloaded['src_save_path'] = downloaded['pip_dl_d'] + '/' + downloaded['src_save_path'].str.get(0)


print('Adding File info to data')

downloaded['dl_fn_ext'] = downloaded['src_save_path'].apply(os.path.splitext)
downloaded['dl_fn'] = downloaded['dl_fn_ext'].str.get(0)
downloaded['dl_ext'] = downloaded['dl_fn_ext'].str.get(1)

print('Adding pkg metadata information')

downloaded['pkginfo'] = downloaded['src_save_path'].progress_apply(get_pkginfo)
downloaded['attributes'] = downloaded['pkginfo'].progress_apply(get_pkginfo_attr)

print(downloaded.head())

print('Saving working dataset')

downloaded.to_csv('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr_noprod.csv',
                  index=False)
downloaded.to_pickle('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr_noprod.pickle')

print('Done.')
