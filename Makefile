
#CC=clang++
CC=g++

BINARY='prgm.run'

all:outputDir
	$(CC) 'src/main.cpp' --std=c++11 -o $(BINARY)

clean:
	rm $(BINARY)
	rm -r out/

submitSlurmJob:
	sbatch 'slurmSubmissionScript.sh'

outputDir:
	if [ ! -d 'out/findPrimes/' ];then mkdir --parents 'out/findPrimes/';fi

