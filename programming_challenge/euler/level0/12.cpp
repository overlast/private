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

  int get_triangle_num(int num) {
    int result = 0;
    int i = 0;
    if (0 == num % 2) {
      result = (num + 1) * (num / 2);
    }
    else {
      result = (num + 1) * (num / 2) + (num / 2 + 1);
    }
    return result;
  }  

  int get_divisors_num(int num, int& step) {
    int result = 0;
    int i = 0;
    int max = num;
    for (i = 1; i < max; i++) {
      if (0 == (num % i)) {
	result++;
	max = num / i;
	result++;
      }
      step++;
    }
    return result;
  }

  int get_divisors_num2(int num, int& step) {
    int result = 0;
    int i = 2;
    int comb = 0;
    if (0 == num % 2) { 
      int tmp = 0;
      while (0 == num % 2) {
	num = num / 2;
	tmp++;
	step++;
      }
      tmp++;
      if (0 == comb) { comb = tmp; } 
      else { comb *= tmp; }
    }
    if (num > 0) {
      for (i = 3; i <= num; i+=2) {
	int tmp = 0;
	if (0 == num % 1) { 
	  while (0 == num % i) {
	    num = num / i;
	    tmp++;
	    step++;
	  }
	  tmp++;
	  if (0 == comb) { comb = tmp; } 
	  else { comb *= tmp; }
	}
      }
    }    
    result = comb;
    return result;
  }
  
  int solve(int num) {
    int result = 0;
    int div = 0;
    int count = 1;
    int step = 0;
    if (num > 0) { 
      while (div < num) {
	int tri = get_triangle_num(count);
	div = get_divisors_num(tri, step);
	count++;
	result = tri;
      }
      cout << "step : " << step << ", result : " << result << endl;

      step = 0; div = 0;count= 1;      
      while (div < num) {
	int tri = get_triangle_num(count);
	div = get_divisors_num2(tri, step);
	count++;
	result = tri;
      }
      cout << "step : " << step << ", result : " << result << endl;
      step= 0; 
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

