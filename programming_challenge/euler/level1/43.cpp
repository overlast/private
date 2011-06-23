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
  
  
  bool is_pandigital(ll num) {
    bool res = true;
    int arr[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    while (num > 0) {
      int amari = num % 10;
      if (arr[amari] > 0) {
	res = false;
	break;
      }
      arr[amari]++;
      num /= 10;
    }
    return res;
  }
  
  string lltos(ll num)  {
    string str;
    stringstream ss;
    ss << num;
    ss >> str;
    return str;
  }

  ll stoll(string str)  {
    ll num;
    stringstream ss;
    ss << str;
    ss >> num;
    return num;
  }
  
  bool is_divisible(ll num) {
    bool res = true;
    int prime[] = {0,2,3,5,7,11,13,17};
    int arr[] = {0,0,0,0,0,0,0,0,0};
    string str = lltos(num);
    for (int i = 1; i <= 7; i++) {
      arr[i] = stoll(str.substr(i, 3));
      if (0 != arr[i] % prime[i]) {
	res = false;
	break;
      }
    }
    return res;
  }

  map <int, int> get_product_mii(int num) {
    map <int, int> mii;
    int i = 1;
    while ((num * i) < 1000) {
      if ((num * i) > 11) {
	if (is_pandigital((ll)(num * i))) {
	  mii[num * i] = 1;
	}
      }
      i++;
    }
    return mii;
  }

  vector <int> get_product_vi(int num) {
    vector <int> vi;
    int i = 1;
    while ((num * i) < 1000) {
      if ((num * i) > 11) {
	if (is_pandigital((ll)(num * i))) {
	  vi.push_back(num * i);
	}
      }
      i++;
    }
    return vi;
  }

  ll solve(void) {
    ll result = 0;
    vector <int> vi17 = get_product_vi(17);
    for (int i = 0; i < vi17.size(); i++) {
      map <int, int> tmii;
      vector <int> pvi;
      int tnum = vi17[i];
      if (tnum < 100) { tmii[0]++; }
      while (tnum > 0) {
	tmii[tnum % 10]++;
	tnum /= 10;
      }
      for (int j = 0; j <= 9; j++) {
	if (1 != tmii[j]) { pvi.push_back(j); }
      }
      do {
	if (0 == pvi[0]) { continue; }
	if ((5 != pvi[5]) && (0 != pvi[0])) { continue; }
	if (0 != pvi[3] % 2) { continue; }
	ll pmnum = 0;
	for (int k = 0; k < pvi.size(); k++) {
	  pmnum = pmnum * 10 + pvi[k];
	}
	pmnum = pmnum * 1000 + vi17[i];
	if (is_pandigital(pmnum)) {
	  if (is_divisible(pmnum)) {
	    //cout << pmnum << endl;
	    result += pmnum;
	  }
	}
      } while(next_permutation(pvi.begin(), pvi.end()));
    }
    return result;
  }
};


int main(int argc, char *argv[]) {
  ll result = 0;
  Solution obj;
  result = obj.solve();
  cout << result << endl;
  return 0;
}

