#!/usr/bin/env python

import fileinput
import argparse
import os
import glob

def replace_in_file(file_path, search_text, new_text):
    with fileinput.input(file_path, inplace=True) as file:
        for line in file:
            new_line = line.replace(search_text, new_text)
            print(new_line, end='')


def get_largest_folder():
    """Determine the largest folder in the path"""
    cwd = os.getcwd()
    time_files = glob.glob(cwd+"/processor0/*")
    times = []
    for f in time_files:
        _split = f.split("/")[-1]
        if _split == 'constant':
            pass
        else:
            times.append(int(_split))
    times.sort()
    print(times,time_files)
    return times[-1]
        
    
# Create the parser
parser = argparse.ArgumentParser(description="update the velocity")

# Add arguments for number of processors and file name
parser.add_argument(
    '-n', '--num_processors',
    type=int,
    required=True,
    help="Number of processors"
)

parser.add_argument(
    '-in', '--in_velocity',
    type=str,
    required=True,
    help="In velocity"
)

parser.add_argument(
    '-out', '--out_velocity',
    type=str,
    required=True,
    help="Out velocity"
)

# Parse the command line arguments
args = parser.parse_args()

# Access the arguments
num_processors = args.num_processors
in_velocity = args.in_velocity
out_velocity = args.out_velocity
folder_name = get_largest_folder()

old_line=f"massFlowRate    constant {in_velocity};"
new_line=f"massFlowRate    constant {out_velocity};"

for n_proc in range(num_processors):
    file = f"processor{n_proc}/{folder_name}/U"
    replace_in_file(file,old_line,new_line)

file="constant/transportProperties"
## Output File - as string
old_line=f"file_out tcat_velocity_{in_velocity};"
new_line=f"file_out tcat_velocity_{out_velocity};"
replace_in_file(file,old_line,new_line)


## As number
old_line=f"v_in v_in [0 1 -1 0 0 0 0] {in_velocity};"
new_line=f"v_in v_in [0 1 -1 0 0 0 0] {out_velocity};"
replace_in_file(file,old_line,new_line)
