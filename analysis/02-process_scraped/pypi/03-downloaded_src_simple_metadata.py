import os
import pandas as pd
from pathlib import Path
from tarfile import ReadError
import pkginfo as pkg
import seaborn as sns
from tqdm import tqdm
import re


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


def df_pkginfo_attr(pkginfo_attr_dict):
    return pd.DataFrame.from_dict(pkginfo_attr_dict, orient='index').T


def parse_class_dev(classifiers, dev_pattern):
    try:
        match_string = [x for x in classifiers if p.search(x.lower())][0]
        return match_string
    except IndexError:
        return None
    except TypeError:
        return None
    except:
        print(classifiers)
        assert False


def parse_dev_status(dev_string, dev_status_pattern='(?<=-).*'):
    try:
        return re.findall(dev_status_pattern, dev_string)[0].strip()
    except TypeError:
        if dev_string == None:
            return None
        else:
            assert False

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

tqdm.pandas()

print('Adding pkg metadata information')

downloaded['pkginfo'] = downloaded['src_save_path'].progress_apply(get_pkginfo)
downloaded['attributes'] = downloaded['pkginfo'].progress_apply(get_pkginfo_attr)

print(downloaded.head())

attr_df = list(map(df_pkginfo_attr, downloaded['attributes']))
print(attr_df[:5])
t = pd.concat(attr_df, sort=False)

assert len(attr_df) == len(downloaded)

print("Combining metadata to downloaded table")

d = pd.concat([downloaded.reset_index(), t.reset_index()], axis='columns')

print("Parsing the development status")

p = re.compile('^development status')
d['dev_status_str'] =  d['classifiers'].apply(parse_class_dev, dev_pattern=p)
d['dev_status'] = d['dev_status_str'].apply(parse_dev_status)

cts = d['dev_status'].value_counts(dropna=False)
cts

print("Saving...")

d.to_csv('./data/oss2/processed/pypi/simple_pkg_metadata.csv', index=False)

print("Done.")