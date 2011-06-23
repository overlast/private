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

  vector <ll> get_prime(ll max) {
    vector <ll> vec;
    ll i = 0;
    ll j = 0;
    for (i = 1; i <= (max / 2); i++) {
      if (1 == i) { continue; } 
      else if (2 == i) { vec.push_back(i); } 
      else if (3 == i) { vec.push_back(i); } 
      else if (5 == i) { vec.push_back(i); } 
      else if (7 == i) { vec.push_back(i); } 
      else {
	if ((0 == (i % 2)) || (0 == (i % 3)) || (0 == (i % 5)) || (0 == (i % 7)) ) { continue; }
	int is_not_prime = 0;
	for (j = 4; j < vec.size(); j++) {
	  if (0 == (i % vec[j])) { is_not_prime = 1;  break; }
	}
	if (1 == is_not_prime) { continue; }
	vec.push_back(i);
      }
    }
    return vec;
  }
  
  ll solve(ll num) {
    ll result = 0;
    vector <ll> prime_vec = get_prime(num);
    ll i = 0;
    ll tmp = num;
    vector <ll> factor_vec;
    for (i = (prime_vec.size() - 1); i >= 0; i--) {
      if (0 == (tmp % prime_vec[i])) {
	factor_vec.push_back(prime_vec[i]);
	//cout << prime_vec[i] << endl;
	tmp = tmp / prime_vec[i];
      }
    }
    return factor_vec[0];
  }

};

// BEGIN CUT HERE
int main(int argc, char *argv[]) {
  ll result = 0;
  Solution* obj = new Solution();
  ll num = atoll(argv[1]);
  result = obj->solve(num);
  cout << result << endl;
  return 0;
}
// END CUT HERE

