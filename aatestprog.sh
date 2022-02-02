#!/bin/bash
#SBATCH --nodes=4
#SBATCH --exclusive
#SBATCH --account=hun@cpu
#SBATCH --time 00:50:00


module load nvidia-compilers/20.11

export DR_NVTX=1
export DR_HOOK=1
export DR_HOOK_OPT=prof
export DR_HOOK_IGNORE_SIGNALS=-1

ulimit -c 0

cd $SLURM_SUBMIT_DIR

ulimit -s unlimited
export OMP_NUM_THREADS=1

set -x
set -e

\rm -f AATESTPROG.fa 

#xport NVDEBUG=1
#xport NVCOMPILER_ACC_DEBUG=1

#DR_HOOK_NOT_MPI=1 ./bin/AATESTPROG --namelist fort.4.20x20 --lmpoff --time 1 

#srun -n 1 nsys profile -t openacc,cuda -s none \
#./bin/AATESTPROG --namelist fort.4.100x100 --time 20 --check --no-write

#srun -n 4 nsys profile -t openacc,cuda -s none \
#     ./bin/AATESTPROG --namelist fort.4.100x100 --time 10 --no-write --alloperm

srun --mpi=pmix -n 1 nsys profile -t mpi,nvtx -s cpu \
     ./bin/AATESTPROG --namelist fort.4.1000x1000 --time 10 --no-write --alloperm




