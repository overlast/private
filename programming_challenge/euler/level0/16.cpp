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
typedef unsigned long long ull;
typedef unsigned int uint;

class Solution {
  
public:
  
  int stoi (string str) {
    int num = 0; stringstream ss;  
    //static const string empty_string;
    ss << str; ss >> num;
    //ss.str(empty_string);ss.clear();
    return num;
  }

  string itos (int num) {
    string str; stringstream ss;  
    //static const string empty_string;  
    ss << num; ss >> str;
    //ss.str(empty_string); ss.clear();
    return str;
  }
  
  string ml_sum (string f, string s) {
    string result = "";
    int i, j = 0;
    int len = f.size();
    string buf = "";
    int carry = 0;
    int is_f_zefo = 0;
    int is_s_zefo = 0;
    
    for (i = 0; i < f.size(); i++) {
      if (f.compare(i, 1, "0") != 0) { break; } 
    }
    if (f.size() == i) { is_f_zefo = 1; }
    for (i = 0; i < s.size(); i++) {
      if (s.compare(i, 1, "0") != 0) { break; } 
    }
    if (s.size() == i) { is_s_zefo = 1; }    
    if ((is_f_zefo > 0) && (is_s_zefo > 0)) {}
    else if (is_f_zefo > 0) { result = s; }
    else if (is_s_zefo > 0) { result = f; }
    else {
      if (len > s.size()) { len = s.size(); }        
      //cout << len << endl;
      for (i = 0; i < len; i++) {
	int num_f = stoi(f.substr(f.size() - 1 - i, 1));
	int num_s = stoi(s.substr(s.size() - 1 - i, 1));
	int total = carry + num_f + num_s;
	string hitoketa = itos(total % 10);
	buf = hitoketa + buf;
	if (total > 9) { carry = 1; }
	else { carry = 0; }      
      }
      //cout << carry << ":" << buf << endl;
      if (f.size() > len) {
	while (carry > 0) {
	  //cout << f.size() - len << endl;
	  if (f.size() - len <= 0) { 
	    buf = itos(carry) + buf;
	    carry = 0;
	  } 
	  else {
	    int num_f = stoi(f.substr(f.size() - 1 - len, 1));
	    //cout << num_f << endl;
	    int total = carry + num_f;
	    //cout << total << endl;
	    string hitoketa = itos(total % 10);
	    buf = hitoketa + buf;
	    //cout << buf << endl;	  
	    if (total > 9) { carry = 1; }
	    else { carry = 0; }
	    len++;
	    //cout << carry << endl;	  
	  }      
	}
	//cout << buf << endl;	  
	if (f.size() - len > 0) {
	  string str_f = f.substr(0, f.size() - len);
	  buf = str_f + buf;
	}
      }
      else {
	while (carry > 0) {
	  int num_s = stoi(s.substr(s.size() - 1 - len, 1));
	  int total = carry + num_s;
	  string hitoketa = itos(total % 10);
	  buf = hitoketa + buf;
	  if (total > 9) { carry = 1; }
	  else { carry = 0; }
	  len++;
	}
	if (s.size() - len > 0) {
	  string str_f = s.substr(0, s.size() - len);
	  buf = str_f + buf;
	}
      }
      result = buf;
    }
    return result;
  }

  string ml_multi (string f, string s) {
    string result = "0";
    int i, j = 0;    
    if ((f.size() == 0) || (s.size() == 0)) {
    }
    else {
      for (i = 0; i < f.size(); i++) {
	int f_num = stoi(f.substr(i, 1));
	string buf = "";
	if (0 == f_num) {
	  buf = "0";
	}
	else {
	  int carry = 0;
	  for (j = 0; j < s.size(); j++) {
	    int s_num = stoi(s.substr(s.size() - 1 - j, 1));
	    int total = carry + f_num * s_num;
	    //cout << "total : " << total << ",s_num : " << s_num << ",f_num : " << f_num << ",carry : " << carry <<  endl;
	    carry = total / 10;//1
	    string tmp = itos(total % 10);//0
	    buf = tmp + buf;//0
	  }
	  if (carry != 0) {
	    string tmp = itos(carry);
	    buf = tmp + buf;
	  }
	}
	result = result + "0";
	//cout << "result 1: " << result << ",buf : " << buf << endl;
	result = ml_sum(result, buf);
	//cout << "result 2: " << result << endl;
	//cout << result << endl;
      }
    }
    return result;  
  }

  int solve2(int num) {
    int result = 0;
    string str = ml_multi("99", "1024");
    return result;
  }

  int solve(int num) {
    int result = 0;
    int i = 0;
    string total;
    int amari = 0;
    if (num >= 0) { 
      total = "1";
      while (num >= 10) {	
	//cout << total << endl;
	if (num >= 10) {
	  total = ml_multi(total, "1024");
	  num = num - 10; 
	}
	//cout << "num : " << num << ",total : " << total << endl;
      }
      //cout << "num : " << num << endl;
      for (i = 0; i < num; i++) {
	total = ml_multi(total, "2");
	//cout << num << ":" <<  total << endl;
      }
    }
    cout << total << endl;

    if (total.size() > 0) {
      for (i = 0; i < total.size(); i++) {
	result += stoi(total.substr(i, 1));
      }
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

