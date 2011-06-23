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
    vector <int> res;
    int i, j = 0;
    res.push_back(0);
    for (i = 1; i <= 9; i++) {
      int tmp = 1;
      for (j = 1; j <= num; j++) {
	tmp *= i;
      }
      res.push_back(tmp);
    }
    return res;
  }

  int solve(int num) {
    int result = 0;
    int i = 0;
    int j = 0;
    int max = 0;
    int count = 0;
    int tmp = 1;
    
    if (num > 1) {
      vector <int> nvec = make_vec(num);
      
      while (max >= count) {
	if (0 == count) { count = 1;}
	max += nvec[9];
	count *= 10;
      }
      //cout << max << endl;
      
      for (i = 2; i <= max; i++) {
	int cn = i;
	int bn = 0;
	while (cn > 0) {
	  int right = cn % 10;
	  bn += nvec[right];
	  cn /= 10;
	}
	if (bn == i) {
	  result += bn;
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

