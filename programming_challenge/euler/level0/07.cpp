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
	  for (j = 2; j < i; j++) {
	    if((1 == vec[j]) && (0 == (i % j))) {
	      vec[i] = 0; break;
	    }
	  }
	}
	if (1 == vec[i]) {
	  for (j = i * i; j <= max; j *= i) {
	    if (j < vec.size()) {
	      vec[j] = 0;
	    }
	  }
	}
      }
    }
    return vec;
  }

  int solve(int num, int buf) {
    int result = 0;
    int i, j = 0;
    vector <int> prime_vec = get_prime_vec(buf);
    int count = 0;
    for (i = 2; i <= prime_vec.size(); i++) {
      if (1 == prime_vec[i]) {
	count++;
      }
      if (num <= count) {
	result = i;
	break;
      } 
    }
    return result;
  }
};

int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int num = atoi(argv[1]);
  int buf = atoi(argv[2]);
  result = obj.solve(num, buf);
  cout << result << endl;
  return 0;
}
