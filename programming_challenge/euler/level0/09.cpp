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

//stringstream ss;
//static const string empty_string;
//ss << str[i]; ss >> num; ss.str(empty_string);ss.clear(); tmp *= num;

class Solution {
public:
  int solve(int num) {
    int result = 0;
    int a, b, c = 0;
    for (a = (num - 2); a >= 1; a--) {
      for (b = (num - a - 1); b > a; b--) {
	for (c = (num - a - b); c > b; c--) {
	  if ((c * c) == ((a * a) + (b *b))) {
	    if (a + b + c == num) {
	      cout << a <<":"<< b << ":"<< c << endl;
	      result = a*b*c;
	    }
	  }
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

