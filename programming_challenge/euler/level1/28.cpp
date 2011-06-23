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
    
  int solve(int num) {
    int result = 0;
    int count = 0;
    int h = 0;
    int i = 0;
    int j = 0;
    for (h = 1; h <= num; h += 2) {
      if (1 == h) {
	count = 1;
	result += count;
      }
      else {
	j = h - 1;
	for (i = 0; i < 4; i++) {
	  count += j;
	  result += count;
	}
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

