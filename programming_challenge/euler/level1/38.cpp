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
  
  
  bool is_include_zero(int num) {
    bool res = false;
    while (num > 0) {
      if (0 == num % 10) {
	res = true;
	break;
      }
      num /= 10;
    }
    return res;
  }
  
  bool is_pandigital(ll num) {
    bool res = true;
    int arr[] = {0,0,0,0,0,0,0,0,0,0};
    while (num > 0) {
      int amari = num % 10;
      if (arr[amari] > 0) { res = false; break; }
      arr[amari]++;
      num /= 10;
    }
    return res;
  }

  ll solve(int limit) {
    ll result = 0;
    for (int i = 1; i <= limit; i++) {
      ll num = 0;
      bool is_end = false;
      for (int j = 1; j <= 9; j++) {
	int tmp = i * j;
	int div = 1;
	if (is_include_zero(tmp)) { break; }
	while (div * 10 < tmp) {
	  div *= 10;
	}
	while (tmp > 0) {
	  if (((num * 10) + (tmp / div)) <= 987654321) {
	    num = (num * 10) + (tmp / div);
	  }
	  else {
	    is_end = true;
	    break;
	  }
	  tmp %= div;
	  div /= 10;
	}
	if (is_end) { break; }
	if (num > 99999999) { break; }
      }
      
      if ((!is_end) && (is_pandigital(num)) && (num > result)) {
	result = num;
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

