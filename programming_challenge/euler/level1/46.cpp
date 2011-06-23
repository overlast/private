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

  vector <int> get_prime_vec(int num) {
    vector <int> vec;
    for (int i = 0; i <= num; i++) {
      if (0 != i % 2) { vec.push_back(1); }
      else { vec.push_back(0); }
    }
    if (num > 0) {
      vec[1] = 0;
      if (num > 1) {
	vec[2] = 1;
	for (int i = 3; i <= num; i += 2) {
	  if (1 == vec[i]) {
	    for (int j = i + i; j <= num; j += i) {
	      vec[j] = 0;
	    }
	  }
	}
      }
    }
    return vec;
  }

  vector <int> get_square_vec(int num) {
    vector <int> vec;
    vec.push_back(0);
    for (int i = 1; i <= num; i++) {
      vec.push_back(2 * i * i);
    }
    return vec;
  }

  int solve(int limit) {
    int result = 0;
    vector <int> pvec = get_prime_vec(limit);
    vector <int> svec = get_square_vec(limit);
    for (int i = 3; i < pvec.size(); i += 2) {
      if (0 == pvec[i]) {
	bool is_ok = false;
	for (int j = 1; j < svec.size(); j++) {
	  if (i <= svec[j]) { break; }
	  if (1 == pvec[i - svec[j]]) {
	    is_ok = true;
	    break;
	  }
	}
	if (!(is_ok)) { result = i; break; }
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

