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

  map <int, int> get_pentagonal_map(int num) {
    map <int, int> mii;
    for (int i = 1; i <= num; i++) {
      mii[i * (3 * i - 1) / 2]++;
    }
    return mii;
  }

  
  int solve(int num) {
    int result = 0;
    map <int, int> mii = get_pentagonal_map(num);
    map <int, int>::iterator i;
    map <int, int>::iterator j;
    for (i = mii.begin(); i != mii.end(); i++) {
      for (j = i; j != mii.end(); j++) {
	if (i->first >= j->first) { continue; }
	int sum = i->first + j->first;
	if (mii.find(sum) != mii.end()) {
	  int dif = j->first - i->first;
	  if (mii.find(dif) != mii.end()) {
	    //cout << dif << endl;
	    result = dif;
	    break;
	  }
	}
      }
      if (result > 0) { break; }
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

