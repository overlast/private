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
    int i = 2;
    int j = 0;
    for (i = 2; i <= num; i++) {
      bool is_prime = true;
      for (j = 2; j <= i/2; j++) {
	if (0 == i % j) { is_prime = false; break; }
      }
      if (is_prime) {
	if (0 == num % i) {
	  while (0 == num % i) {
	    vec.push_back(i);
	    num = num / i;
	  }
	}
      }
    }
    return vec;
  }
  
  string itos(int num) {
    string res;
    stringstream ss;
    ss << num;
    ss >> res;
    return res;
  }

  int solve(int a, int b) {
    int result = 0;
    int i = 0;
    int j = 0;
    int k = 0;
    vector <string> svec;
    for (i = 2; i <= a; i++) {
      vector <int> vec = make_vec(i);
      for (j = 2; j <= b; j++) {
	int bn = 0;
	int cn = 0;
	string str = "";
	for (k = 0; k < vec.size(); k++) {
	  if (bn != vec[k]) { 
	    if (cn > 0) {
	      str = str + ":" + itos(cn * j) + ",";
	      cn = 0;
	    }
	    str += itos(vec[k]); bn = vec[k]; cn = 1;
	  }
	  else if (bn == vec[k]) { cn++; }
	}
	if (cn > 0) {
	  str = str + ":" + itos(cn * j) + ",";
	  cn = 0;
	}
	svec.push_back(str);
      }
    }
    sort(svec.begin(), svec.end());
    string bs;
    for (i = 0; i < svec.size(); i++) {
      if (bs != svec[i]) { result++; }
      bs = svec[i];
    }
    return result;
  }
};


int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int a = atoi(argv[1]);
  int b = atoi(argv[2]);
  result = obj.solve(a, b);
  cout << result << endl;
  return 0;
}

