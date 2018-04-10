
#include <cassert>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

int parseCfg(string filePath);
void findNFirstPrimes(vector<int>& primes, const int nbPrimesToFind);
bool isPrime(int candidate, vector<int> primes);
void saveToFile(string filePath, vector<int> primes);

int main(int argc, char* argv[])
{
    bool hasOneArgument = (argc==2); //argv[0] is program name
    assert(hasOneArgument);
    string cfgFile = argv[1];

    const int nbPrimesToFind = parseCfg(cfgFile);
    vector<int> primes;
    findNFirstPrimes(primes, nbPrimesToFind);
    saveToFile("out/findPrimes/out.txt", primes);

    return 0;
}

int parseCfg(string filePath)
{
    string line;
    ifstream inputFile(filePath, ios::in);

    if (not inputFile.is_open())
    {
        cerr << "Error: file \"" + filePath + "\"could not be opened." << endl;
        abort();
    }

    getline(inputFile,line);
    int nbPrimesToFind = stoi(line);
    inputFile.close();
    return nbPrimesToFind;
}

void findNFirstPrimes(vector<int>& primes, const int nbPrimesToFind)
{
    //Prime numbers 1 and 2 are assumed to be known already
    int candidateNb = 3;
    int nbPrimesFound=2;
    while(nbPrimesFound < nbPrimesToFind)
    {
        if(isPrime(candidateNb, primes))
        {
            primes.push_back(candidateNb);
            nbPrimesFound++;
        }
        candidateNb += 2; //Even numbers can be divided by 2 => are not primes
    }
    //Not computationally efficient but who cares
    primes.insert(primes.begin(),{1,2});

    //If nbPrimesToFind <= 2, then we want to get rid of the extra prime numbers
    //E.g. nbPrimesToFind=1 => primes = {1}
    //E.g. nbPrimesToFind=0 => primes = {}
    while(primes.size() > nbPrimesToFind)
        { primes.pop_back(); }
}

bool isPrime(int candidate, vector<int> primes)
{
    for(int prime : primes)
    {
        if(candidate % prime == 0)
            { return false; }
    }
    return true;
}

void saveToFile(string filePath, vector<int> primes)
{
    ofstream outputFile;
    outputFile.open(filePath, ios::out | ios::trunc);

    if(not outputFile.is_open())
    {
        cerr << "Error: file \"" + filePath + "\"could not be opened." << endl;
        abort();
    }

    for(int atom : primes)
        { outputFile << atom << endl; }
    outputFile.close();
}

