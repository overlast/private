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
  
  map <int, int> get_prime_map(int num) {
    map <int, int> mii;
    vector <int> vec;
    for (int i = 0; i <= num; i++) {
      if (0 == i % 2) { vec.push_back(0); }
      else { vec.push_back(1); }
    }
    if (num > 0) {
      vec[1] = 0;
      if (num > 1) {
	vec[2] = 1;
	for (int j = 3; j <= num; j += 2) {
	  if (1 == vec[j]) {
	    for (int k = j + j; k <= num; k += j) {
	      vec[k] = 0;
	    }
	  }
	}
      }
    }
    for (int i = 0; i < vec.size(); i++) {
      if (1 == vec[i]) { mii[i]; }
    }
    cout << mii.size() << endl;
    return mii;
  }


  ll solve(int num) {
    ll result = 0;
    int max = 0;
    map <int, int> mii = get_prime_map(num);
    map <int, int>::iterator i;
    map <int, int>::iterator j;
    for (i = mii.begin(); i != mii.end(); i++) {
      ll total = 0;
      int count = 0;
      for (j = i; j != mii.end(); j++) {
	total += j->first;
	if (total > num) { break; }
	count++;
	//cout << total << ":" << count << endl;
	if (mii.find(total) != mii.end()) {
	  if (count > max) {
	    max = count;
	    result = total;
	  }
	}
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

