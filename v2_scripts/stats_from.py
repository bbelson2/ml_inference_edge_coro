import pandas as pd
import numpy as np
import sys

def stats_from_file(in_path):
    ds = pd.read_csv(in_path)
    ds['ratio1'] = ds.shift(1)['cpu_cycles']/ds['cpu_cycles']
    ds['ratio2'] = ds.shift(2)['cpu_cycles']/ds['cpu_cycles']
    ds_5 = ds[ds['test_num'] == 5]
    ds_6 = ds[ds['test_num'] == 6]
    (mean_5, sd_5) = (ds_5['ratio1'].mean(), ds_5['ratio1'].std())
    (mean_6, sd_6) = (ds_6['ratio2'].mean(), ds_6['ratio2'].std())
    return [mean_5, sd_5, mean_6, sd_6]

def main(in_path, argv):
    stats = stats_from_file(in_path)
    # Append all args after file name (passed through from command line) to data line
    print(",".join(argv + [str(s) for s in stats]))

if __name__ == "__main__":
    # 1st arg should be input file.
    # All subsequent arguments will be passed through to the CSV output
    main(sys.argv[1], sys.argv[2:])

    
