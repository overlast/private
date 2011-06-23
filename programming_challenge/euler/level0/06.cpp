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
  ll solve(int max) {
    ll result = 0;
    int i = 0;
    ll square = 0;
    ll sum = 0;

    for (i = 1; i <= max; i++ ) {
      square = square + (i * i);
    }
    for (i = 1; i <= max; i++ ) {
      sum = sum + i;
    }
    sum = sum * sum;

    result = sum - square;
    
    return result;
  }
};

// BEGIN CUT HERE
int main(int argc, char *argv[]) {
  ll result = 0;
  Solution obj;
  int num = atoi(argv[1]);
  result = obj.solve(num);
  cout << result << endl;
  return 0;
}
// END CUT HERE

