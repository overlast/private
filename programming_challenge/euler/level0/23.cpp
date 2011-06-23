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
  
  bool is_abundant(int num) {
    bool result = false;
    int total = 0;
    int i = 0;
    for (i = 1; i <= num / 2; i++) {
      if (0 == num % i) {
	total += i;
      }
    }
    if (total > num) {
      result = true;
    }
    return result;
  }

  vector <char> make_abundant_vec(int num) {
    vector <char> vec;
    int i = 0;
    vec.push_back('0');
    for (i = 1; i <= num; i++) {
      if (true == is_abundant(i)) {
	vec.push_back('1');
      }
      else {
	vec.push_back('0');
      }
    }
    return vec;
  }

  int solve(int num) {
    int i, j = 0;
    int result = 0;
    vector <char> vec = make_abundant_vec(num);

    for (i = 1; i <= num; i++) {
      bool is_sum = false;
      for (j = 1; j <= i / 2; j++) {
	if ('1' == vec[j]) {
	  int other = i - j;
	  if ('1' == vec[other]) {
	    is_sum = true;
	    break;
	  }
	}
      }
      if (!is_sum) {
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

