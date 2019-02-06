import os
import pandas as pd
from pathlib import Path
from tarfile import ReadError # error when parsing src pkg
import pkginfo as pkg
import seaborn as sns
import re

from tqdm import tqdm
tqdm.pandas()


def get_pkginfo(f):
    fp, ext = os.path.splitext(f)
    #print(f)
    try:
        if ext == '.whl':
            return pkg.Wheel(f)
        elif ext == '.gz':
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

downloaded_pkgs = os.listdir('./data/oss2/original/pypi/pypi_simple/simple_pkg_src/')
download_info = pd.read_csv('./data/oss2/processed/pypi/simple_url_src_paths.csv')

print(download_info.head())

download_info['file_downloaded'] = download_info['src_save_path'].apply(os.path.isfile)
print(download_info['file_downloaded'].head())

downloaded = download_info.loc[download_info.file_downloaded == True]

print(downloaded.head())

print('Adding File info to data')

downloaded['dl_fn_ext'] = downloaded['src_save_path'].apply(os.path.splitext)
downloaded['dl_fn'] = downloaded['dl_fn_ext'].str.get(0)
downloaded['dl_ext'] = downloaded['dl_fn_ext'].str.get(1)

# sns.countplot(x='dl_ext', data=downloaded)

print('Adding pkg metadata information')

downloaded['pkginfo'] = downloaded['src_save_path'].progress_apply(get_pkginfo)
downloaded['attributes'] = downloaded['pkginfo'].progress_apply(get_pkginfo_attr)

print(downloaded.head())

print('Saving working dataset')

downloaded.to_csv('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.csv', index=False)
downloaded.to_feather('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.feather')
downloaded.to_pickle('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.pickle')
