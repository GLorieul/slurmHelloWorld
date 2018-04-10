#!/bin/bash

#SBATCH --job-name=findPrimes
#SBATCH --mail-user=gael.lorieulgl@laposte.net
#SBATCH --mail-type=ALL
#SBATCH --output="slurm_%j_findPrimes.log"
#SBATCH --time=0-04:00
#SBATCH --partition=Def
#SBATCH --ntasks=1          #a
#SBATCH --cpus-per-task=1   #b
#SBATCH --ntasks-per-node=1 #c
#SBATCH --mem-per-cpu=350

#Note: calls to SBATCH must be at the very beginning of the file otherwise they are ignored.
#To understand the role of each option: see manual.
#Other options available: see manual.



# MAKE BASH TERMINAL VERBOSE

#It's always nice to see in the slurm log how files have been copied before
# & after code run, even if it looks ugly.

set -x



# SET VARIABLES STORING FOLDERS LOCATIONS

ROOTDIR="${SLURM_SUBMIT_DIR}/"
WORKDIR="${LOCALSCRATCH}/glorieul/${SLURM_JOB_ID}"
SAVEDIR="${SLURM_SUBMIT_DIR}/out/out_slurm_${SLURM_JOB_ID}"

printf "SLURM_JOB_ID     = %s\n" "${SLURM_JOB_ID}"
printf "GLOBALSCRATCH    = %s\n" "${GLOBALSCRATCH}"
printf "LOCALSCRATCH     = %s\n" "${LOCALSCRATCH}"
printf "SLURM_SUBMIT_DIR = %s\n" "${SLURM_SUBMIT_DIR}"
printf "----------------------------------\n"
printf "ROOTDIR          = %s\n" "${ROOTDIR}"
printf "WORKDIR          = %s\n" "${WORKDIR}"
printf "SAVEDIR          = %s\n" "${SAVEDIR}"

mkdir --parents ${WORKDIR}
mkdir --parents ${SAVEDIR}



# COPY INPUT DATA REQUIRED FOR SIMULATION

# Each cluster has a head node and computation nodes
#  - Binary compilation and job submission is done on head node
#  - Upon call to sbatch, slurm books a/several CPU(s) on a/several
#    computation node(s)
#  - When login on to the cluster via ssh, one usually lands on the head node
#    by default.
# Hence binary, input files and output directories must be accessible by the
# corresponding computation node(s).
# There is a so-called "scratch" disk space that is accessible by all nodes
# (both head & computation nodes).
# On scratch a user-specific folder is used to save simulation input, output
# and code binary.
# Hence before binary is called, input data (e.g. configuration files) and
# binary must be copied on the scratch space, and the output directories must
# be created.

mkdir --parents "${WORKDIR}/in"
cp -r "${ROOTDIR}/in/cfg/"   "${WORKDIR}/in/"
cp -r "${ROOTDIR}/prgm.run"  "${WORKDIR}"
mkdir --parents "${WORKDIR}/out/findPrimes"

cd ${WORKDIR}



# MODULE LOADING & UNLOADING

# If you don't load the proper modules you might have issues.
# E.g. if you compile binary on head node using gcc version Y But that
# computation node has gcc version X (< Y), then upon execution there might
# be errors because libstd of correct version could not be found (dynamic linking).

#module unload GCC/4.8.2 hwloc/1.7.2-GCC-4.8.2 OpenMPI/1.7.3-GCC-4.8.2 fftw3/gcc/3.3.3
#module load OpenMPI/1.10.3-GCC-5.4.0-2.26



# RUN BINARY

# I used mostly sequential jobs => not completely sure about instructions for MPI & friends.

# RUN BINARY : SEQUENCIAL JOB

#./prgm.run in/cfg/sc_risingBubble_veloGrid_reinit10.cfg
 
# RUN BINARY : OpenMP JOB

# Set the number of treads equal to those requested with the 
# --cpus-per-task option.
#export OMP_NUM_THREADS=b
#./a.out
 
# RUN BINARY : MPI JOB

# The MPI implementations are aware of the Slurm environment. The
# following line will launch the number of processes that was 
# requested with the --ntasks option on the nodes that were allocated
# by Slurm. 

#module load openmpi/1.6.1/gnu64 
#mpirun ./a.out

#mpirun -np 1 "./prgm.run" "./in/cfg/sc_risingBubble_veloGrid_reinit10.cfg"

# RUN BINARY : HYBRID MPI/OpenMP JOB

# Mix the above. Note that due to an unsolved misunderstanding between
# Slurm and OpenMPI, the SLURM_CPUS_PER_TASK environment variable must
# be unset. 
 
#export OMP_NUM_THREADS=b
#unset SLURM_CPUS_PER_TASK
#module load openmpi/1.6.1/gnu64
#mpirun ./a.out



# COPY OUTPUT FILES BACK HOME

cp -rf ${WORKDIR}/* ${SAVEDIR}
rm -rf ${WORKDIR}



# APPEND RUN INFO TO LOG

sacct --format="JobID,NCPU,CPUTime,MaxRss" -j ${SLURM_JOB_ID}



# - END OF JOB -

