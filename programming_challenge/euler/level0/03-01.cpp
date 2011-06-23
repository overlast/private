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

  ll solve(ll num) {
    ll result = 0;
    vector <ll> factors;
    ll i, j = 0;
    for (i = 1; i <= num; i++) {
      if (1 == i) { continue; }
      else {
        while (0 == (num % i)) {
          num = num / i;
          factors.push_back(i);
          //      cout << i << endl;                                                                                 
        }
      }     
      if (0 == num) {
            break;
      }
    }
    if (factors.size() > 0) {
      result = factors.back();
    }
    return result;
  }

};

// BEGIN CUT HERE
int main(int argc, char *argv[]) {
  ll result = 0;
  Solution obj;
  ll num = atoll(argv[1]);
  result = obj.solve(num);
  cout << result << endl;
  return 0;
}
// END CUT HERE

