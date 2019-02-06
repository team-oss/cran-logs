import pandas as pd
import numpy as np
import re

from tqdm import tqdm
tqdm.pandas()

def df_pkginfo_attr(pkginfo_attr_dict):
    """Convert attributes dictionary to a wide dataframe.
    """
    return pd.DataFrame.from_dict(pkginfo_attr_dict, orient='index').T


print("Loading data...", end='')
downloaded = pd.read_pickle('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.pickle')
print('done.')

print("Converting attributes dictionary to dataframe...", end='')
attr_df = list(map(df_pkginfo_attr, downloaded['attributes']))
print("concatenating...", end='')
t = pd.concat(attr_df, sort=False)
print('done.')

assert len(attr_df) == len(downloaded)

print("Combining metadata to downloaded table")

d = pd.concat([downloaded.reset_index(), t.reset_index()], axis='columns')

print('saving')
d.to_pickle('./data/oss2/processed/working/pypi/parsed_pkg_attributes.pickle')
print('script done.')