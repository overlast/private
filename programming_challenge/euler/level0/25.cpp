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

  string itos(int num) {
    string res = "";
    stringstream ss;
    ss << num;
    ss >> res;
    return res;
  }

  int stoi(string str) {
    int res = 0;
    stringstream ss;
    ss << str;
    ss >> res;
    return res;
  }

  string ml_sum(string s1, string s2) {
    string result = "";
    int i, j = 0;
    if ((1 == s1.size()) && ('0' == s1[0])) { result = s2; }
    else if ((1 == s2.size()) && ('0' == s2[0])) { result = s1; }
    else {
      string buf = "";
      int carry = 0;
      int len = s1.size();
      if (len > s2.size()) { len = s2.size(); }
      for (i = 0; i < len; i++) {
	int n1 = stoi(s1.substr(s1.size() - 1 - i, 1));
	int n2 = stoi(s2.substr(s2.size() - 1 - i, 1));
	int total = carry + n1 + n2;
	carry = total / 10;
	buf = itos(total % 10) + buf;
      }
      if (s1.size() > s2.size()) {
	int l = s1.size() - s2.size();
	for (i = 0; i < l; i++) {
	  if (carry > 0) {
	    int n = stoi(s1.substr(l - 1 - i, 1));
	    int t = n + carry % 10;
	    carry = carry / 10 + t / 10;
	    buf = itos(t % 10) + buf;
	  }
	  else {
	    string ssbstr = s1.substr(0, l - i);
	    buf = ssbstr + buf;
	    break;
	  }
	}
      }
      else if (s1.size() < s2.size()) {
	int l = s2.size() - s1.size();
	for (i = 0; i < l; i++) {
	  if (carry > 0) {
	    int n = stoi(s2.substr(l - 1 - i, 1));
	    int t = n + carry % 10;
	    carry = carry / 10 + t / 10;
	    buf = itos(t % 10) + buf;
	  }
	  else {
	    string ssbstr = s2.substr(0, l - i);
	    buf = ssbstr + buf;
	    break;
	  }
	}
      }
      if (carry > 0) {
	string cs = itos(carry);
	buf = cs + buf;
      }
      if (buf.size() > 0) { result = buf; }
    }
    return result;
  }
  
  int solve(int num) {
    int result = 0;
    int count = 0;
    string buf1 = "1";count++;
    string buf2 = "1";count++;
    string buf3 = "";
    while (buf3.size() < num) {
      buf3 = ml_sum(buf1, buf2);
      //cout << buf3 << endl;
      buf1 = buf2;
      buf2 = buf3;
      count++;
    }
    result = count;
    return result;
  }
};

int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int num = atoi(argv[1]);
  result = obj.solve(num);
  cout << result << endl;
  return 0;
}

