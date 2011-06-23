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

  string ml_multi(string s1, string s2) {
    string result = "";
    int i, j = 0;
    if ((1 == s1.size()) && ('0' == s1[0])) { result = "0"; }
    else if ((1 == s2.size()) && ('0' == s2[0])) { result = "0"; }
    else {
      for (i = 0; i < s1.size(); i++) {
	int n1 = stoi(s1.substr(i,1));	
	string buf = "";
	int nc = 0;
	for (j = s2.size() - 1; j >= 0; j--) {
	  int n2 = stoi(s2.substr(j,1));
	  int nt = nc + n2 * n1;
	  //cout << buf << ":" << n1 << ":" << n2 << ":" << nc <<":"<<nt << endl;
	  nc = nt / 10;
	  buf = itos(nt % 10) + buf;
	}
	if (nc > 0) {
	  buf = itos(nc) + buf;
	}
	result = result + "0";
	result = ml_sum(result, buf);
      }
    }
    return result;
  }

  int solve(int num) {
    string result = "";
    /*
    result = ml_sum("1000", "999000"); cout << result << endl;
    result = ml_sum("999000", "1000"); cout << result << endl;
    result = ml_sum("1", "999"); cout << result << endl;
    result = ml_sum("999", "1"); cout << result << endl;
    result = ml_sum("11", "1111"); cout << result << endl;
    result = ml_sum("1111", "11"); cout << result << endl;
    result = ml_sum("909091", "90909"); cout << result << endl;
    result = ml_sum("90909", "909091"); cout << result << endl;
    result = ml_multi("99", "1"); cout << result << endl;
    result = ml_multi("1", "99"); cout << result << endl;
    result = ml_multi("9", "10"); cout << result << endl;
    result = ml_multi("10", "9"); cout << result << endl;
    result = ml_multi("10", "99"); cout << result << endl;
    result = ml_multi("99", "10"); cout << result << endl;
    result = ml_multi("99999999", "10000000000"); cout << result << endl;
    result = ml_multi("10000000000", "99999999"); cout << result << endl;
    result = ml_multi("14", "6227020800"); cout << result << endl;
    result = ml_multi("6227020800", "14"); cout << result << endl;
    */

    result = ml_sum("6765","10946"); cout << result << endl;

    return 1;
  }

  int solve2(int num) {
    int result = 0;
    int i = 0;
    string buf = "0";
    for (i = num; i >= 1; i--) {
      //cout << buf << endl;
      string sn = itos(i);
      if ('0' == buf[0]) { buf = sn; }
      else { buf = ml_multi(buf, sn); }
    }
    //cout << buf << endl;
    for (i = 0; i < buf.size(); i++) {
      result += stoi(buf.substr(i,1));
    }
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

