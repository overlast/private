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
  
  
  vector <int> make_vec(int num) {
    vector <int> vec;
    for (int i = 0; i <= num; i++) {
      if (0 == i % 2) { vec.push_back(0); }
      else { vec.push_back(1); }
    }
    if (num > 0) {
      vec[1] = 0;
      if (num > 1) {
	vec[2] = 1;
	for (int j = 3; j <= num; j += 2) {
	  if (1 == vec[j]) {
	    for (int k = j + j; k <= num; k += j) {
	      vec[k] = 0;
	    }
	  }
	}
      }
    }
    return vec;
  }
  
  vector <int> get_truncate_vec(int num) {
    vector <int> vec;
    int div = 1;
    while (div * 10 <= num) {
      div *= 10;
    }
    while (num > 0) {
      vec.push_back(num);
      num = num % div;
      div /= 10;
    }
    return vec;
  }
  
  bool is_not_include_zero(int num) {
    bool is_ok = true;
    while (num > 0) {
      if (0 == num % 10) {
	is_ok = false;
	break;
      }
      num /= 10;
    }
    return is_ok;
  }

  bool is_right_valid(int num, vector <int> &vec) {
    bool is_ok = true;
    while (num > 0) {
      if (0 == vec[num]) {
	is_ok = false;
	break;
      }
      num /= 10;
    }
    return is_ok;
  }

  bool is_left_valid(int num, vector <int> &vec) {
    bool is_ok = true;
    vector <int> truncate_vec = get_truncate_vec(num);
    int j = 0;
    for (j = 0; j < truncate_vec.size(); j++) {
      if (1 == vec[truncate_vec[j]]) {}
      else {
	is_ok = false;
	break;
      }
    }
    return is_ok;
  }

  int solve(int num) {
    int result = 0;
    int limit = 1000000;
    vector <int> prime_vec = make_vec(limit);
    int count = 0;
    for (int i = 11; i < limit; i++) {
      if (1 == prime_vec[i]) {
	if (is_not_include_zero(i)) {
	  if (is_right_valid(i, prime_vec)) {
	    if (is_left_valid(i, prime_vec)) {
	      result += i;
	      count++;
	    }
	  }
	}
      }
      if (count >= num) { break;}
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

