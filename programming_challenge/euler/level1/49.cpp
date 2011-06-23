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
  
  vector <int> make_prime_vec(int limit) {
    vector <int> vec;
    for (int i = 0; i <= limit; i++) {
      if (0 == i % 2) { vec.push_back(0); }
      else { vec.push_back(1); }
    }
    if (limit > 0) {
      vec[1] = 0;
      if (limit > 1) {
	vec[2] = 0;
	for (int i = 3; i <= limit; i += 2) {
	  if (1 == vec[i]) {
	    for (int j = i + i; j <= limit; j += i) {
	      vec[j] = 0;
	    }
	  }
	}
      }
    }
    return vec;
  }

  typedef pair< pair<int, int>, int> ppiii;

  struct second_order {
    bool operator()(const ppiii &x, const ppiii &y) const {
      return x.second > y.second;
    }
  };
  
  bool is_permutation(int i, int j) {
    bool res = true;
    vector <int> vi1;
    vector <int> vi2;
    while (i > 0) {
      vi1.push_back(i % 10);
      i /= 10;
    }
    while (j > 0) {
      vi2.push_back(j % 10);
      j /= 10;
    }
    sort(vi1.begin(), vi1.end());
    sort(vi2.begin(), vi2.end());
    for (int k = 0; k < vi1.size(); k++) {
      if (vi1[k] != vi2[k]) {
	res = false;
	break;
      }
    }
    return res;
  }

  ll get_con_num(vector <pair <int, int> > &vpii) {
    ll res = 0;
    for (int i = 0; i < vpii.size(); i++) {
      for (int j = i + 1; j < vpii.size(); j++) {
	if (vpii[i].first == vpii[j].second) {
	  res = vpii[j].first;
	  res = res * 10000 + vpii[j].second;
	  res = res * 10000 + vpii[i].second;
	}
	else if (vpii[i].second == vpii[j].first) {
	  res = vpii[i].first;
	  res = res * 10000 + vpii[i].second;
	  res = res * 10000 + vpii[j].second;
	}
      }
    }
    return res;
  }

  vector <ll> solve(int start, int limit) {
    vector <ll> result;
    vector <int> prime_vec = make_prime_vec(limit);
    priority_queue <ppiii, vector<ppiii>, second_order > pq;
    for (int i = start; i <= limit; i++) {
      if (1 == prime_vec[i]) {
	for (int j = i + 1; j <= limit; j++) {
	  if (1 == prime_vec[j]) {
	    if (is_permutation(i, j)) {
	      pq.push(pair< pair<int, int>, int>(pair<int, int>(i, j), j - i));
	    }
	  }
	}
      }
    }
    vector <pair <int, int> > vpii;
    int val = 0;
    while (!pq.empty()) {
      ppiii item = pq.top();
      //cout << item.second << ":" << (item.first).first << ":" << (item.first).second << endl;
      if (val == item.second) {
	vpii.push_back(item.first);
      }
      else {
	if (vpii.size() > 0) {
	  ll tmp = get_con_num(vpii);
	  if (tmp > 0) {
	    result.push_back(tmp);
	  }
	  //cout << "res:" << result << endl;
	}
	//if (result > 0) { break; }
	vpii.clear();
	val = item.second;
	vpii.push_back(item.first);
      }
      pq.pop();
    }
    if (vpii.size() > 0) {
      ll tmp = get_con_num(vpii);
      if (tmp > 0) {
	result.push_back(tmp);
      }
    }
    return result;
  }
};


int main(int argc, char *argv[]) {
  vector <ll> result;
  Solution obj;
  int num1 = atoi(argv[1]);
  int num2 = atoi(argv[2]);
  result = obj.solve(num1, num2);
  for (int i = 0; i < result.size(); i++) {
    cout << result[i] << endl;
  }
  return 0;
}

