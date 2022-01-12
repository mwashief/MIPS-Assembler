#include<iostream>
#include<cmath>
#include<fstream>
#include<vector>
using namespace std;


class Segment
{
public:
    string name = "";
    int pc = 0;
    vector<Segment*> alist;

    Segment()
    {
        name = "";
    }

    Segment(string f)
    {
        name = f;
    }

    bool operator==(Segment& rhs)
    {
        return name == rhs.name;
    }

    Segment operator=(Segment& rhs)
    {
        name = rhs.name;
        return *this;
    }
    string getName() {return name;}

    string getCode()
    {
        string s = "";
        for(int i=0; i<alist.size(); i++)
        {
            s = s + alist[i]->name;
        }
        return s;
    }

    friend ostream& operator<<(ostream& os, Segment rhs)
    {
    os << "<" << rhs.name << ">";
    return os;
    }
};
