import pandas as pd
import numpy as np
import re

from tqdm import tqdm
tqdm.pandas()

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


def parse_dev_status(dev_string, dev_status_pattern='(?<=development status).*'):
    try:
        return re.findall(dev_status_pattern, dev_string.lower())[0].strip()
    except AttributeError: # when None is passed for dev_string
        return None
    except:
        print(dev_string)
        assert False


def clean_dev_status(status_string):
    try:
        if re.search('-', status_string): # if there is a dash in the string
            return re.findall('(?<=-).*', status_string.lower())[0].strip()
        elif re.search('::', status_string): # if the double colon :: exists in the string
            return re.findall('(?<=::).*', status_string.lower())[0].strip()
        else:
            print(status_string)
            return np.nan
    except TypeError: # When string is None
        #print(status_string)
        return np.NaN



downloaded = pd.read_pickle('./data/oss2/processed/working/pypi/simple_downloaded_pkginfo_attr.pickle')

attr_df = list(map(df_pkginfo_attr, downloaded['attributes']))
print(attr_df[:5])
t = pd.concat(attr_df, sort=False)

assert len(attr_df) == len(downloaded)

print("Combining metadata to downloaded table")

d = pd.concat([downloaded.reset_index(), t.reset_index()], axis='columns')

print("Parsing the development status")

p = re.compile('^development status')
d['dev_status_str'] =  d['classifiers'].progress_apply(parse_class_dev, dev_pattern=p)
d['dev_status'] = d['dev_status_str'].progress_apply(parse_dev_status)

cts = d['dev_status'].value_counts(dropna=False)
cts

print("Saving...")

d.to_csv('./data/oss2/processed/pypi/simple_pkg_metadata.csv', index=False)

print("Done.")

attr_df = list(map(df_pkginfo_attr, downloaded['attributes']))
print(attr_df[:5])
t = pd.concat(attr_df, sort=False)

assert len(attr_df) == len(downloaded)

print("Combining metadata to downloaded table")

d = pd.concat([downloaded.reset_index(), t.reset_index()], axis='columns')

print("Parsing the development status")

p = re.compile('^development status')
d['dev_status_str'] =  d['classifiers'].progress_apply(parse_class_dev, dev_pattern=p)
d['dev_status'] = d['dev_status_str'].progress_apply(parse_dev_status)

cts = d['dev_status'].value_counts(dropna=False)
cts

d['dev_status_clean'] = d['dev_status'].progress_apply(clean_dev_status)

cts = d['dev_status_clean'].value_counts(dropna=False)
cts

cts['production/stable'] + cts['mature']

