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
    if (num >= 1) {
      vec[0] = 0; vec[1] = 0;
      if (num >= 2) {
	vec[1] = 1;
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
  
  int permute(int num) {
    int i = 0;
    int amari = num % 10;
    num /= 10;
    for (i = 10; i < num; i *= 10) {}
    num += amari * i;
    return num;
  }

  vector <int> get_permute_vec(int num) {
    vector <int> vec;
    int tmp = 0;
    vec.push_back(num);
    tmp = permute(num);
    vec.push_back(tmp);
    while (tmp != num) {
      tmp = permute(tmp);
      vec.push_back(tmp);
    }
    return vec;
  }
  
  bool is_permuteable(int num) {
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

  int solve(int num) {
    int result = 0;
    vector <int> vi = make_vec(num);
    for (int i = 0; i <= num; i++) {
      if (1 <= vi[i]) {
	if (i <= 11) { vi[i] = 2; }
	else if (is_permuteable(i)) {
	  vector <int> p_vi = get_permute_vec(i);
	  int j = 0;
	  for (j = 0; j < p_vi.size(); j++) {
	    if (0 == vi[p_vi[j]]) { break; }
	  }
	  if (j == p_vi.size()) {
	    for (j = 0; j < p_vi.size(); j++) {
	      if ((p_vi[j] <= num) && (vi[p_vi[j]] == 1)) {
		vi[i] = 2;
	      }
	    }
	  }
	}
      }
    }
    for (int i = 0; i <= vi.size(); i++) {
      if (vi[i] == 2) {
	result++;
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

