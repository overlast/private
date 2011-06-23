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
    int result = 1;
    int target = 1;
    int len = 0;
    for (int i = 1; i <= limit; i++) {
      int div = 1;
      int num = i;
      int tmp = 1;
      int tmp_len = 1;
      while ((div * 10) <= num) { div *= 10; tmp_len++; }
      len += tmp_len;
      if (len > target) {
	int att = len - target;
	for (int j = 1; j <= att + 1; j++) {
	  tmp = num % 10;
	  num /= 10;
	}
	result *= tmp;
	target *= 10;
      }
      else {
	if (len == target) {
	  tmp = num % 10;
	  result *= tmp;
	  target *= 10;
	}
      }
      if (target > limit) { break; }
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

