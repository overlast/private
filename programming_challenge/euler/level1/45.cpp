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

  map <ll, int> get_triangle_map(ll b, ll e) {
    map <ll, int> mii;
    for (ll i = b; i <= e; i++) {
      mii[i * (i + 1) / 2]++;
    }
    return mii;
  }

  map <ll, int> get_pentagonal_map(ll b, ll e) {
    map <ll, int> mii;
    for (ll i = b; i <= e; i++) {
      mii[i * (3 * i - 1) / 2]++;
    }
    return mii;
  }

  map <ll, int> get_hexagonal_map(ll b, ll e) {
    map <ll, int> mii;
    for (ll i = b; i <= e; i++) {
      mii[i * (2 * i - 1)]++;
    }
    return mii;
  }

  ll solve(ll limit) {
    ll result = 0;
    map <ll, int> triangle = get_triangle_map(286, limit);
    map <ll, int> pentagonal = get_pentagonal_map(166, limit);
    map <ll, int> hexagonal = get_hexagonal_map(144, limit);
    map <ll, int>::iterator j;
    for (j = hexagonal.begin(); j != hexagonal.end(); j++) {
      ll num = j->first;
      if (pentagonal.find(num) == pentagonal.end()) { continue; }
      if (triangle.find(num) == triangle.end()) { continue; }
      result = num;
      break;
    }
    return result;
  }
};


int main(int argc, char *argv[]) {
  ll result = 0;
  Solution obj;
  ll num = atoi(argv[1]);
  result = obj.solve(num);
  cout << result << endl;
  return 0;
}

