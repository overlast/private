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

  map <int, int> make_map(int num) {
    map <int, int> mii;
    for (int i = 2; i <= num; i++) {
      if (0 == num % i) {
	while (0 == num % i) {
	  mii[i]++;
	  num = num / i;
	}
      }
    }
    return mii;
  }

  int solve(int a, int b) {
    set < map <int, int> > smii;
    for (int i = 2; i <= a; i++) {
      map <int, int> mii = make_map(i);
      string str = "";
      for (int j = 2; j <= b; j++) {
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

