#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <climits>
#include <cfloat>
#include <map>
#include <utility>
#include <set>
#include <iostream>
#include <memory>
#include <string>
#include <vector>
#include <algorithm>
#include <functional>
#include <sstream>
#include <complex>
#include <stack>
#include <queue>
using namespace std;
static const double EPS = 1e-5;
typedef long long ll;
typedef unsigned int uint;

class Solution {
  
public:

  vector <int> make_vec(int num) {
    vector <int> vec;
    int i = 0;
    int j = 0;
    for (i = 2; i <= num; i++) {
      if (0 == num % i) {
	while (0 == num % i) {
	  vec.push_back(i);
	  num = num / i;
	}
      }
    }
    return vec;
  }

  int solve(int a, int b) {
    int result = 0;
    set < map <int, int> > smii;
    int i = 0;
    int j = 0;
    for (i = 2; i <= a; i++) {
      vector <int> vec = make_vec(i);
      string str = "";
      map <int, int> mii;
      for (j = 0; j < vec.size(); j++) { mii[vec[j]]++; }
      for (j = 2; j <= b; j++) {
	map <int, int> tmii;
	for (map <int, int>::iterator it = mii.begin(); it != mii.end(); it++) {
	  tmii[(*it).first] = (*it).second * j;
	}
	smii.insert(tmii);
      }
    }
    return smii.size();
  }
};


int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int a = atoi(argv[1]);
  int b = atoi(argv[2]);
  result = obj.solve(a, b);
  cout << result << endl;
  return 0;
}

