import pandas as pd
import re
import numpy as np

from tqdm import tqdm
tqdm.pandas()

def parse_class_dev(classifiers, dev_pattern):
    try:
        match_string = [x for x in classifiers if dev_pattern.search(x.lower())][0]
        return match_string
    except IndexError:
        return None
    except TypeError:
        return None
    except AttributeError: ## when NaN
        return None
    except:
        print(classifiers)
        assert False

test_classifier = ['Development Status :: 5 - Production/Stable',
 'Environment :: Console',
 'Operating System :: OS Independent',
 'Intended Audience :: Science/Research',
 'Programming Language :: Python',
 'Programming Language :: Python :: 2',
 'Programming Language :: Python :: 3',
 'Programming Language :: Python :: 2.7',
 'Programming Language :: Python :: 3.5',
 'Programming Language :: Python :: 3.6',
 'Programming Language :: Python :: 3.7',
 'Programming Language :: Cython',
 'Topic :: Scientific/Engineering']
p_test = re.compile('^development status')
assert parse_class_dev(test_classifier, p_test) == 'Development Status :: 5 - Production/Stable'

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


df = pd.read_pickle('./data/oss2/processed/working/pypi/parsed_pkg_attributes_noprod.pickle')

print("Parsing the development status")

p = re.compile('^development status')
df['dev_status_str'] =  df['classifiers'].progress_apply(parse_class_dev, dev_pattern=p)
df['dev_status'] = df['dev_status_str'].progress_apply(parse_dev_status)
df['dev_status_clean'] = df['dev_status'].progress_apply(clean_dev_status)

print("Saving")
df.to_pickle('./data/oss2/processed/working/pypi/production_ready_noprod.pickle')
df.to_csv('./data/oss2/processed/working/pypi/production_ready_noprod.csv', index=False)

# dev_status counts
cts = df['dev_status'].value_counts(dropna=False)
print(cts)
df['dev_status_clean'].value_counts(dropna=False)
cts_clean = df['dev_status_clean'].value_counts(dropna=False)
cts_clean['production/stable'] + cts_clean['mature']

# found a mistake in how the packages were originally downloaded,
# so we are not saving the final production ready status here

#production_ready = df.loc[(df['dev_status_clean'] == 'production/stable') | (df['dev_status_clean'] == 'mature')]
#production_ready.shape
#assert production_ready.shape[0] == cts_clean['production/stable'] + cts_clean['mature']

#print('Saving production ready dataset')
#production_ready.to_pickle('./data/oss2/processed/working/pypi/production_ready.pickle')
#production_ready.to_csv('./data/oss2/processed/working/pypi/production_ready.csv', index=False)

print('Script done.')
