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

  bool is_pandigital(int num) {
    bool res = true;
    int arr[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    while (num > 0) {
      int amari = num % 10;
      if ((0 == amari) || (amari > 7) || (arr[amari] >= 1)) {
	res = false;
	break;
      }
      arr[amari]++;
      num /= 10;
    }
    return res;
  }

  bool is_prime(int num) {
    bool res = true;
    if (0 == num % 2) { res = false; }
    else {
      for (int i = 3; i <= num/2; i++) {
	if (0 == num % i) {
	  res = false;
	  break;
	}
      }
    }
    return res;
  }

  int solve(void) {
    int result = 0;
    for (int i = 7654321; i >= 1000000; i-= 2) {
      if (is_pandigital(i)) {
	if (is_prime(i)) {
	  result = i;
	  break;
	}
      }
    }
    if (0 == result) { 
      for (int i = 4321; i >= 10000; i-= 2) {
	if (is_pandigital(i)) {
	  if (is_prime(i)) {
	    result = i;
	    break;
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
  result = obj.solve();
  cout << result << endl;
  return 0;
}

