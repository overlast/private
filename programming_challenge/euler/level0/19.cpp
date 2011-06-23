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
  
  vector <int> make_vec(string s) {
    vector <int> v;
    stringstream ss;
    static const string empty_string;
    int num = 0;
    if (('-' == s[4]) && ('-' == s[7])) {
      ss << s.substr(0,4); ss >> num;
      v.push_back(num);
      ss.str(empty_string);ss.clear();
      ss << s.substr(5,2); ss >> num;
      v.push_back(num);
      ss.str(empty_string);ss.clear();
      ss << s.substr(8,2); ss >> num;
      v.push_back(num);
      ss.str(empty_string);ss.clear();
    }
    return v;
  }
  
  int solve(string b, string e) {
    int result = 0;
    int y, m, d = 0;
    vector <int> bv = make_vec(b);
    vector <int> ev = make_vec(e);
    
    int n_uruu[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int uruu[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    
    int count = 0;
    bool is_start = false;
    int begin = 0;
    bool is_end = false;
    for (y = 1900; y <= ev[0]; y++) {
      for (m = 1; m <= 12; m++) {
	if ((0 == y % 4) && ((0 != y % 100) || (0 == y % 400)))  {
	  for (d = 1; d <= uruu[m - 1]; d++) {
	    if ((y >= ev[0]) && ((m == 12) || (m >= ev[1])) && ((d == uruu[m - 1]) || (d >= ev[2]))) { is_start = true; is_end = true;}
	    else if ((y >= bv[0]) && ((m == 12) || (m >= bv[1])) && ((d == uruu[m - 1]) || (d >= bv[2]))) { is_start = true; }
	    else { begin++; }
	    if (is_start) {
	      count++;
	      if ((1 == d) && (0 ==(count - (7 - (begin % 7))) % 7)) {
		result++;
	      }
	    }
	    if (is_end) { break;}

	  }
	}
	else {
	  for (d = 1; d <= n_uruu[m - 1]; d++) {
	    if ((y >= ev[0]) && ((m == 12) || (m >= ev[1])) && ((d == n_uruu[m - 1]) || (d >= ev[2]))) { is_start = true; is_end = true;}
	    else if ((y >= bv[0]) && ((m == 12) || (m >= bv[1])) && ((d == n_uruu[m - 1]) || (d >= bv[2]))) { is_start = true; }
	    else { begin++; }
	    if (is_start) {
	      count++;
	      if ((1 == d) && (0 ==(count - (7 - (begin % 7))) % 7)) {
		result++;
	      }
	    }
	    if (is_end) { break;}
	  }
	}
	if (is_end) { break;}
      }
      if (is_end) { break;}
    }
    return result;
  }
};

int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  string b = argv[1];
  string e = argv[2];
  result = obj.solve(b, e);
  cout << result << endl;
  return 0;
}

