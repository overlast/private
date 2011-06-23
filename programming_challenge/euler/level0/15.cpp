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
typedef unsigned long long ull;
typedef unsigned int uint;

class Solution {
  
public:
  
  ll solve(int num) {
    ll result = 0;
    vector <vector <ll> > vec;
    int i, j = 0;
    num = num * 2;
    if (num > 0) {
      for (i = 0; i <= num; i++) {
	vector <ll> tmp;
	for (j = 0; j <= num; j++) {
	  tmp.push_back(0);
	}
	vec.push_back(tmp);
      }

      for (i = 0; i <= num; i++) {
	vec[i][0] = 1;
      }
      
      for (i = 1; i <= num; i++) {
	for (j = 1; j <= i; j++) {
	  if (0 == vec[i - 1][j]) {
	    vec[i][j] = 1;
	  }
	  else {
	    vec[i][j] = vec[i - 1][j] + vec[i - 1][j -1];
	  }
	}
      }
    }

    result = vec[num][num / 2];
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

