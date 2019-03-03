import pandas as pd
import numpy as np
import re

from tqdm import tqdm
tqdm.pandas()

def df_pkginfo_attr(pkg_name, pkginfo_attr_dict):
    """Convert attributes dictionary to a wide dataframe.
    """
    trans = pd.DataFrame.from_dict(pkginfo_attr_dict, orient='index').T
    trans['name'] = pkg_name
    return trans

print("Loading data...", end='')
downloaded = pd.read_pickle('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr_noprod.pickle')
print('done.')

print("Converting attributes dictionary to dataframe...", end='')
attr_df = list(map(df_pkginfo_attr, downloaded['name_pypi'], downloaded['attributes']))
print("concatenating...", end='')
t = pd.concat(attr_df, sort=False)
print('done.')

assert len(attr_df) == len(downloaded)

print("Droping columns")
# because we are re-using the initial pypi metadata table, we want to drop the old columns before concatenating the new columns
# we do this because duplicate columns become a problem in the next script
dup_cols = list(t.columns)
downloaded.drop(dup_cols, axis='columns', inplace=True, errors='ignore')


print("Combining metadata to downloaded table")

# alignment seems to mess things up so it's just safer to do a join
#d = pd.concat([downloaded.reset_index(), t.reset_index()], axis='columns')
d = pd.merge(downloaded, t, how='outer', left_on='name_pypi', right_on='name')
assert d.shape[0] == downloaded.shape[0]

print('saving')
d.to_csv('./data/oss2/processed/working/pypi/parsed_pkg_attributes_noprod.csv', index=False)
d.to_pickle('./data/oss2/processed/working/pypi/parsed_pkg_attributes_noprod.pickle')
print('script done.')
