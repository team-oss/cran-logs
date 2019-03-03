import pandas as pd

no_prod = pd.read_pickle('./data/oss2/processed/working/pypi/production_ready_noprod.pickle')
ye_prod = pd.read_pickle('./data/oss2/processed/working/pypi/production_ready_first_pass.pickle')

# should not have anymore duplicate columns
# this is just looking at counts, not actually comparing duplicate values
assert len(no_prod.columns) == len(set(no_prod.columns))
assert len(ye_prod.columns) == len(set(ye_prod.columns))

rdy_no_prod = no_prod.loc[no_prod['dev_status_clean'].isin(['production/stable', 'mature'])]
print(rdy_no_prod.shape)

rdy_ye_prod = ye_prod.loc[ye_prod['dev_status_clean'].isin(['production/stable', 'mature'])]
print(rdy_ye_prod.shape)

# make sure there are not duplicates in either table
assert ~rdy_no_prod['name_pypi'].isin(rdy_ye_prod['name_pypi']).any()
assert ~rdy_ye_prod['name_pypi'].isin(rdy_no_prod['name_pypi']).any()

production_ready = pd.concat([rdy_ye_prod, rdy_no_prod], axis='index')

production_ready.to_pickle('./data/oss2/processed/working/pypi/production_ready.pickle')
production_ready.to_csv('./data/oss2/processed/working/pypi/production_ready.csv', index=False)


print(production_ready.shape)

print(production_ready['dev_status_clean'].value_counts())
