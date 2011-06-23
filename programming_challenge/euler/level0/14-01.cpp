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
    ll i = 0;
    vector <ll> cache;
    for (i = 0; i <= num; i++) {
      cache.push_back(0);
    }
    for (i = 1; i <= num; i++) {
      ll focus = i;
      ll count = 0;
      if (1 == focus) { count = 1; }
      else {
	while (1 != focus) {
	  if (0 == focus % 2) {
	    focus = focus / 2;
	  }
	  else {
	    focus = focus * 3 + 1;
	  }
	  count++;
	  if ((focus <= num) && (0 != cache[focus])) {
	    count += cache[focus];
	    focus = 1;
	  }
	}
      }      
      if (count > max) {
	result = i;
	max = count;
      }
      if((i <= num) && (0 == cache[i])) {
	cache[i] = count;
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

