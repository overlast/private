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
  int solve(int max) {
    int result = 0;
    int sum = 0;
    int num1 = 0;
    int num2 = 0;
    if (max >= 0) {
      cout << max << endl;
      while (sum <= max) {
	if (0 == num1) {
	  num1 = 1;
	  sum = num1;
	}
	else if (0 == num2) {
	  num2 = num1;
	  num1 = 2;
	  sum = num1;
	}
	else {
	  sum = num1 + num2;
	  num2 = num1;
	  num1 = sum;
	}
	
	if (sum > max) { break; }
	
	if (0 == (num1 % 2)) {
	  result += num1;
	}
      }
    }
    return result;
  }
};

// BEGIN CUT HERE
int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int num = atoi(argv[1]);
  result = obj.solve(num);
  cout << result << endl;
  return 0;
}
// END CUT HERE

