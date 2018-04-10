
[Official slurm documentation (manual pages)](https://slurm.schedmd.com/)

# Environment modules

Most clusters use environments modules to set up e.g. compiler version and/or library versions

Get a list of available modules

    user@dragon1-h0$ module list
      1) GCC/4.8.2                 2) hwloc/1.7.2-GCC-4.8.2     3) OpenMPI/1.7.3-GCC-4.8.2   4) fftw3/gcc/3.3.3

Unload modules

    user@dragon1-h0$ module unload GCC/4.8.2 hwloc/1.7.2-GCC-4.8.2 [...]

Load modules

    user@dragon1-h0$ module load OpenMPI/1.10.3-GCC-5.4.0-2.26

# Interacting with Slurm

To submit a job sbatch 

    sbatch slurmSubmissionScript.sh

To predict the scheduling time of job without submitting it

    sbatch --test-only sslurmSubmissionScript.sh

To track current status of jobs:

    squeue -u glorieul --Format=jobid,name,partition,state,timeused,timelimit,nodelist

To have detailled info about a running or previously running job

    sacct --format="CPUTime,MaxRSS,AveRSS,MaxRssNode" -j JOB_SLURM_ID

To tell load of cluster

    sload

To see one's fairshare

    sshare

To see how much disk space is used

    quota --human-readable

