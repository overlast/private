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
      if (0 == i) { vec.push_back(1); }
      else {
	int num = 1;
	for (int j = 1; j <= i; j++) {
	  num *= j;
	}
	vec.push_back(num);
      }
    }
    return vec;
  }
  
  int solve(void) {
    int result = 0;
    vector <int> vi = make_vec(9);
    for (int i = 0; i < (int)vi.size(); i++) {
      cout << vi[i] << endl;
    }
    for (int i = 3; i < 10000000; i++) {
      int tmp = i;
      int sum = 0;
      while (tmp > 0) {
	sum += vi[tmp % 10];
	tmp /= 10;
      }
      //cout << sum << ":" << i << endl;
      if (sum == i) { 
	cout << i << endl;
	result += i;
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

