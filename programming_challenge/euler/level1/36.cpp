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
    string res;
    stringstream ss;
    ss << num;
    ss >> res;
    return res;
  }

  bool is_palindromic(string str) {
    bool res = false;
    int i = 0;
    for (i = 0; i < (str.size()+1)/2; i++) {
      if (str[i] == str[str.size() - 1 - i]) {
      }
      else { break; }
    }
    if (i == (str.size()+1)/2) { res = true; }
    return res;
  }

  string get_2base_str_from_10base_int(int num) {
    string res = "";
    while (num > 0) {
      if (1 == num % 2) { res = "1" + res; }
      else { res = "0" + res;  }
      num /= 2;
    }
    return res;
  }
  
  int solve(int num) {
    int result = 0;
    for (int i = 1; i <= num; i+=2) {
      if (is_palindromic(itos(i))) {
	string tmp = get_2base_str_from_10base_int(i);
	if (is_palindromic(tmp)) {
	  result += i;
	}
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

