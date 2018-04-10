
CC=clang++
#CC=g++

all:
	$(CC) 'src/main.cpp' --std=c++11 -o 'prgm.run'

submitSlurmJob:
	sbatch 'slurmSubmissionScript.sh'

