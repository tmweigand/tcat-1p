#!/bin/bash
#SBATCH --job-name="domain_generation"
#SBATCH --output="domain_generation.%j.%N.out"
#SBATCH --partition=compute
#SBATCH --nodes=10
#SBATCH --ntasks-per-node=100
#SBATCH --mem=0 
#SBATCH --account=nca125
#SBATCH --export=ALL
#SBATCH -t 48:00:00

#This job runs with 1 nodes, 125 cores per node for a total of 128 tasks.

module purge
module load cpu
#Load module file(s) into the shell environment
module load slurm
module load cpu/0.17.3b  gcc/10.2.0/npcyll4
module load openmpi/4.1.1

cp /expanse/lustre/projects/nca125/tweigand/tcat-1p-exact/scripts/generate_domain.sh .
cp /expanse/lustre/projects/nca125/tweigand/tcat-1p-exact/scripts/run_inlet_velocities.sh .
cp /expanse/lustre/projects/nca125/tweigand/tcat-1p-exact/scripts/update_velocity.py .

chmod 777 generate_domain.sh
chmod 777 run_inlet_velocities.sh
chmod 777 update_velocity.py

./generate_domain.sh
./run_inlet_velocities.sh
