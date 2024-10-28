#!/bin/sh
cd "${0%/*}" || exit                                # Run from this directory
. ${WM_PROJECT_DIR:?}/bin/tools/RunFunctions        # Tutorial run functions
#------------------------------------------------------------------------------

canCompile || exit 0    # Dynamic code

rm log.tcat-1p-steady*

restore0Dir

rm log.decomposePar

rm -rf processor*

runApplication decomposePar

rm -rf tcat/

mkdir tcat/

mkdir tcat/local

# Get number of procs
base_dir="."
num_procs=-1
# Loop through all directories that match the pattern 'processor*'
for dir in "${base_dir}/processor"*; do
    # Extract the number from the directory name
    num=$(basename "$dir" | grep -o '[0-9]\+')
    
    # Check if the number is greater than the current max_num
    if [[ $num -gt $num_procs ]]; then
        num_procs=$num
    fi
done
num_procs=$((num_procs + 1))


echo $num_procs

velocity=(1e-07 1e-06 5e-06 1e-05 5e-05 0.0001 0.00025 0.0005 0.00075 0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.15 0.2 0.25 0.3 1e-07)
length=${#velocity[@]}
i=1
while [ $i -ne $((length+1)) ]
do
    # Run code 
    mpirun -np $num_procs tcat-1p-steady -parallel > log.tcat-1p-steady

    # Update velocity
    ./update_velocity.py -n $num_procs -in ${velocity[i-1]} -out ${velocity[i]}
    
    mv log.tcat-1p-steady log.tcat-1p-steady${velocity[i-1]}

    echo $i ${velocity[i-1]}
    
    i=$((i + 1))

done