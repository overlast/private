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
  
  bool is_no_zero(int num) {
    bool res = true;
    while (num > 0) {
      if (0 != num % 10) {
	num /= 10;
      }
      else {
	res = false;
	break;
      }
    }
    return res;
  }

  vector <bool> make_nvi(int num) {
    vector <bool> vi;
    for (int i = 0; i <= num; i++) {
      if (is_no_zero(i)) {
	vi.push_back(true);
      }
      else {
	vi.push_back(false);
      }
    }
    return vi;
  }

  bool is_no_same(int n1, int n2) {
    bool res = true;
    int num = 0;
    map <int, int> mii;
    while (n1 > 0) {
      int amari = n1 % 10;
      mii[amari]++;
      num++;
      n1 /= 10;
    }
    while (n2 > 0) {
      int amari = n2 % 10;
      mii[amari]++;
      num++;
      n2 /= 10;
    }
    if (num != (int)mii.size()) { res = false; }
    return res;
  }

  bool is_pandigital(int n1, int n2, int n3) {
    bool res = true;
    int num = 0;
    map <int, int> mii;
    while (n1 > 0) {
      int amari = n1 % 10;
      mii[amari]++;
      num++;
      n1 /= 10;
    }
    while (n2 > 0) {
      int amari = n2 % 10;
      mii[amari]++;
      num++;
      n2 /= 10;
    }
    while (n3 > 0) {
      int amari = n3 % 10;
      mii[amari]++;
      num++;
      n3 /= 10;
    }
    if (num != 9) { res = false;}
    else if (num != (int)mii.size()) { res = false; }
    return res;
  }

  int solve(void) {
    int result = 0;
    vector <bool> nvi = make_nvi(2000);
    set <int> si;
    for (int i = 1; i < 2000; i++) {
      if (nvi[i]) {
	for (int j = 1; j < 2000; j++) {
	  if (nvi[j]) {
	    if (is_no_same(i, j)) {
	      int pro = i * j;
	      if (is_no_zero(pro)) {
		if (is_pandigital(i, j, pro)) {
		  cout << i << ":" << j << ":" << pro << endl;
		  si.insert(pro);
		}
	      }
	    }
	  }
	}
      }
    }
    set <int>::iterator it = si.begin();
    while(it != si.end()) {
      result += *it;
      it++;
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

