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
  
  vector <int> get_prime_vec(int max) {
    vector <int> vec;
    int i, j = 0;
    for (i = 0; i <= max; i++) {
      vec.push_back(1);
    }
    for (i = 0; i <= max; i++) {
      if (1 == vec[i]) {
	if ((0 == i) || (1 == i)) { vec[i] = 0; }
	else {
	}
	if (1 == vec[i]) {
	  for (j = i + i; j <= max; j += i) {
	    if (j < vec.size()) {
	      vec[j] = 0;
	    }
	  }
	}
      }
    }
    return vec;
  }

  ll solve(int max) {
    ll result = 0;
    ll i, j = 0;
    vector <int> prime_vec = get_prime_vec(max);
    vector <int> marge_vec;
    for (i = 0; i <= max; i++) {
      marge_vec.push_back(0);
    }
    for (i = 2; i <= max; i++) {
      int tmp = i;
      vector <int> tmp_vec;
      for (j = 0; j <= i; j++) {
	tmp_vec.push_back(0);
      }
      for (j = 2; j <= i; j++) {
	if (1 == prime_vec[j]) {
	  while ((tmp > 0) && (0 == (tmp % j))) {
	    tmp_vec[j]++;
	    tmp = tmp / j;
	  }
	}
      }
      for (j = 0; j < tmp_vec.size(); j++) {
	if (0 < tmp_vec[j]) {
	  if (tmp_vec[j] > marge_vec[j]) {
	    marge_vec[j] = tmp_vec[j];
	  }
	}
      }
    }
    for (i = 0; i < marge_vec.size(); i++) {
      if (marge_vec[i] > 0) {
	if (0 == result) {
	  result = i;
	  for (j = 1; j < marge_vec[i]; j++) {
	    result = result * i;
	  }
	}
	else {
	  for (j = 0; j < marge_vec[i]; j++) {
	    result = result * i;
	  }
	}
      }
    }
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
