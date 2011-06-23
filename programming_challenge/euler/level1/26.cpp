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

  int solve(int num) {
    int result = 0;
    int max = 0;
    int i = 0;
    if (num < 3) {}
    else {
      for (i = 3; i <= num; i++ ) {
	set <int> si;
	int count = 0;
	int mot = 1;
	int limit = (i - 1);
	while (limit > count) {
	  int amari = mot * 10 % i;
	  if (0 == amari) { break; }
	  else {
	    if (si.find(amari) == si.end()) {
	      si.insert(amari);
	      mot = amari;
	    }
	    else { break; }
	  }
	  count++;
	}
	if ((si.size() > 0) && (si.size() > max)) {
	  max = si.size();
	  result = i;
	}
      }
    }
    return result;
  }
};


int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int num = atoi(argv[1]);
  result = obj.solve(num);
  cout << result << endl;
  return 0;
}

