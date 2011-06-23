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
  
  bool is_amicable(int num) {
    bool result = false;
    int max = num;
    int i = 0;
    int t1 = 0;
    int t2 = 0;
    int u1 = 0;
    for (i = 1; i <= (num / 2); i++) {
      if (0 == num % i) {
	t1 += i;
      }
    }
    if (t1 != num) { 
      for (i = 1; i <= (t1 / 2); i++) {
	if (0 == t1 % i) {
	  t2 += i;
	}
      }
      if (num == t2) {
	result = true;
      }
    }
    return result;
  }

  int solve(int num) {
    int result = 0;
    int i = 0;
    for (i = 1; i <= num; i++) {
      if (is_amicable(i)) {
	result += i;
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

