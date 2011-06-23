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

  map <int, int> get_factor_map(int num) {
    map <int, int> mii;
    if (1 == num) { mii[1] = 1; }
    else {
      for (int i = 2; i <= num; i++) {
	while (0 == num % i) {
	  mii[i]++;
	  num /= i;
	}
      }
    }
    return mii;
  }

  ll solve(int num, int digit) {
    ll result = 0;
    ll limit = 1;
    for (int i = 0; i < digit; i++) {
      limit *= 10;
    }
    //cout << limit - 1 << endl;
    for (int i = 1; i <= num; i++) {
      map <int, int> mii = get_factor_map(i);
      map <int, int>::iterator j;
      ll tmp = 1;
      for (j = mii.begin(); j != mii.end(); j++) {
	//cout << i << ":" << j->first << ":" << j->second << ":" << j->second * i << endl;
	for (int k = 0; k < (j->second * i); k++) {
	  tmp *= j->first;
	  if (tmp > (limit - 1)) {
	    tmp %= limit;
	  }
	}
      }
      result += tmp;
      if (result > (limit - 1)) {
	result %= limit;
      }
    }
    return result;
  }
};


int main(int argc, char *argv[]) {
  ll result = 0;
  Solution obj;
  int num1 = atoi(argv[1]);
  int num2 = atoi(argv[2]);
  result = obj.solve(num1, num2);
  cout << result << endl;
  return 0;
}

