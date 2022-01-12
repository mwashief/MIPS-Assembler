#include<iostream>
#include <bitset>
#include <cstdio>
#include <fstream>
#include<cstdlib>
using namespace std;
int main(){

    ifstream ifs("Machine Code.txt");
    FILE* logisim;
    logisim = fopen("Logisim.txt", "w");
    string s;
    fprintf(logisim, "v2.0 raw\n");
    while(ifs >> s)
    {
        bitset<20> data(s);
        fprintf(logisim, "%.5x ", data.to_ulong());
    }
    ifs.close();
    fclose(logisim);
}
