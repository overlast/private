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
  
  ll get_sum_of_prime(int max) {
    ll result = 0;
    vector <int> vec;
    ll i, j = 0;
    for (i = 0; i <= max; i++) { vec.push_back(1); }
    if (max < 2) {}
    else {
      vec[0] = 0; vec[1] = 0;
      result += 2;
      if (max > 2) {
	for (i = (2 + 2); i <= max; i += 2) {
	  if (i < vec.size()) { vec[i] = 0; }
	}
	for (i = 3; i <= max; i += 2) {
	  if (1 == vec[i]) {
	    result += i;
	    for (j = i + i; j <= max; j += i) {
	      if (j < vec.size()) {
		vec[j] = 0;
	      }
	    }
	  }
	}
      }
    }
    return result;
  }

  ll solve(int num) {
    ll result = 0;
    result = get_sum_of_prime(num);
    return result;
  }
};

int main(int argc, char *argv[]) {
  ll result = 0;
  Solution obj;
  int num = atoi(argv[1]);
  result = obj.solve(num);
  cout << result << endl;
  return 0;
}
