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

class Solution {
public:

  vector <string> make_prime_vec(string str) {
    vector <string> vec;
    int focus = 0;
    for (int i = 1; i < str.size(); i++) {
      if ('"' == str[i]) {
	string tmp = str.substr(focus+1, i - (focus + 1));
	vec.push_back(tmp);
	i += 2;
	focus = i;
      }
    }
    return vec;
  }

  map <int, int> make_triangle_map(int num) {
    map <int, int> mi;
    for (int i = 1; i <= num; i++) {
      int tmp = (i * (i + 1)) / 2;
      mi[tmp] = 1;
    }
    return mi;
  }

  int solve(void) {
    int result = 0;
    string line;
    cin >> line;
    vector <string> vs = make_prime_vec(line);
    map <int, int> mi = make_triangle_map(1000);
    for (int i = 0; i < vs.size(); i++) {
      int sum = 0;
      for (int j = 0; j < vs[i].size(); j++) {
	int num = vs[i][j] - 64;
	sum += num;	
      }
      if (1 == mi[sum]) {
	result++;
      }
    }
    return result;
  }
};

// BEGIN CUT HERE
int main() {
  int result = 0;
  Solution obj;
  result = obj.solve();
  cout << result << endl;
  return 0;
}
// END CUT HERE


