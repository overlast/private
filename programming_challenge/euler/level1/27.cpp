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
  
  vector <char> get_prime(int a, int b) {
    vector <char> vec;
    ll n = a;
    ll i, j = 0;
    if (n < b) { n = b; }
    n = n * n * n;
    for (i = 0; i <= n; i++) {
      vec.push_back('1');
    }
    if (n > 0) {
      vec[0] = '0'; vec[1] = '0';
      if (n > 1) {
	vec[2] = '1';
	for (i = 2 + 2; i <= n; i+=2) {
	  vec[i] = '0';
	}
	if (n > 2) {
	  for (i = 3; i <= n; i += 2) {
	    bool is_find = false;
	    if ('1' == vec[i]) {
	      for (j = i + i; j <= n; j+=i) {
		vec[j] = '0';
	      }
	    }
	  }
	}
      }
    }
    return vec;
  }

  int get_prime_num(vector <char> &vec, int a, int b) {
    int result = 0;
    int i = 0;
    for (i = 0; i < b; i++) {
      ll tmp = i * i + i * a + b;
      if (tmp >= 0) {
	if ('1' == vec[tmp]) { result++; }
      }
    }
    return result;
  }
  
  int solve(int a, int b) {
    int result = 0;
    int max = 0;
    vector <char> vec = get_prime(a, b);
    int i, j = 0;
    for (i = ((-1 * b) + 1); i < b; i++) {
      if ((0 != i % 2) && (((i > 0) && ('1' == vec[i])) || ((i < 0) && ('1' == vec[i * -1])))) {
      	for (j = ((a * -1) + 1); j < a; j++) {
	  if (0 != j % 2) {
	    int tmp = get_prime_num(vec, j, i);
	    if (tmp > max) {
	      max = tmp; result = i * j;
	      cout << max << ":" << i << ":" << j << endl;
	    }
	  }
	}
      }
    }
    return result;
  }
};


int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int a = atoi(argv[1]);
  int b = atoi(argv[2]);
  result = obj.solve(a, b);
  cout << result << endl;
  return 0;
}

