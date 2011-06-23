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
  
  int solve(int limit) {
    int result = 0;
    int max = 0;
    for (int p = 4; p <= limit; p++) {
      int num = 0;
      int a = 0, b = 0, c = 0;
      for (a = 1; a <= (p - 2); a++) {
	if ((2 * (a - p)) == 0) { continue; }
	b = ((2 * a * p) - (p * p)) / (2 * (a - p));
	if (b < a) { continue;}
	c = p - b - a;
	if (c < b) { continue;}
	if ((a * a + b * b) != (c * c)) { continue;}
	//cout << a << ":" << b << ":" << c << endl;
	num++;
      }
      if (num > max) { max = num; result = p;}
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

