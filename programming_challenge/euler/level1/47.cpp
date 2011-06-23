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

  bool is_primes_factor_num(int num, int con) {
    bool res = true;
    map <int, int> mii;
    for (int i = 2; (i <= num); i++) {
      while (0 == num % i) {
	mii[i]++;
	num /= i;
      }
    }
    if (mii.size() != con) { res = false; }
    return res;
  }

  int solve(int con, int max) {
    int result = 0;
    int consecutive_num = 0;
    for (int i = 1; i <= max; i++) {
      if (is_primes_factor_num(i, con)) {
	consecutive_num++;
	if (0 == result) { result = i; }
      }
      else {
	consecutive_num = 0;
	result = 0;
      }
      if (consecutive_num == con) { break; }
    }
    if (consecutive_num != con) { result = 0; }
    return result;
  }
};


int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int num1 = atoi(argv[1]);
  int num2 = atoi(argv[2]);
  result = obj.solve(num1, num2);
  cout << result << endl;
  return 0;
}

