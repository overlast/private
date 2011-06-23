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
    int i = 1;
    for (i = 0; i <= 9; i++) {
      vec.push_back(i*i*i*i*i);
    }
    return vec;
  }
  
  int solve(void) {
    int result = 0;
    int i = 0;
    int j, k, l, m, n, o = 0;
    int num = 5;
    vector <int> nvec = make_vec(num);
    
    int max = 0;
    int count = 0;
    for (i = 0; i < 10; i++) {
      if (0 == count) {count = 1;}
      max += nvec[9];
      count *= 10;
      if (max < count) {
	break;
      }
    }

    vector <int> sum_vec;
    int step = 0;
    for (j = 0; j < nvec.size(); j++) {
      for (k = 0; k < nvec.size(); k++) {
	for (l = 0; l < nvec.size(); l++) {
	  for (m = 0; m < nvec.size(); m++) {
	    for (n = 0; n < nvec.size(); n++) {
	      for (o = 0; o < nvec.size(); o++) {
		step++;
		int tmp = nvec[j] + nvec[k] + nvec[l] + nvec[m] + nvec[n] + nvec[o];
		if ((tmp <= 1) || (max <= tmp)) { continue; }
		int tmp1 = tmp;
		int tmp2 = 0;
		while (tmp1 > 0) {
		  step++;
		  int right = tmp1 % 10;
		  tmp2 += nvec[right];
		  tmp1 = tmp1 / 10;
		}
		if (tmp == tmp2) {
		  sum_vec.push_back(tmp);
		}
	      }
	    }
	  }
	}
      }
    }
    cout << "step:" << step << endl;
    sort(sum_vec.begin(), sum_vec.end());
    vector <int> uniq_vec;
    int bn = 0;
    for (i = 0; i < sum_vec.size(); i++) {
      if (bn != sum_vec[i]) { uniq_vec.push_back(sum_vec[i]); }
      bn = sum_vec[i];
    }
    
    for (i = 0; i < uniq_vec.size(); i++) {
      result += uniq_vec[i];
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

