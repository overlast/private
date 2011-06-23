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
  
  int stoi(string s) {
    int num = 0;
    stringstream ss;
    ss << s;
    ss >> num;
    return num;
  }
  
  vector <int> make_vec(string str, int digit) {
    vector <int> vec;
    int i = 0;
    for (i = 0; i < str.size(); i = i + digit + 1) {
      if (1 == digit) {
	  vec.push_back(stoi(str.substr(i, digit)));
      }
      else  if (2 == digit) {
	if (str.compare(i, 1, "0") == 0) {
	  vec.push_back(stoi(str.substr(i + 1, digit)));
	}
	else {
	  vec.push_back(stoi(str.substr(i, digit)));
	}
      }
    }
    return vec;
  } 

  int solve(string in, int digit) {
    int result = 0;
    int i, j = 0;
    vector <int> vec = make_vec(in, digit);
    int count = 0;
    for (i = 1, j = 0; j < vec.size(); i++) {
      count++;
      j += i;
    }
    for (i = 1; i <= count; i++) {
      int att = ((1 + i) * i) / 2 - 1;
      if (0 == att) {}      
      else {
	int right = att - i;
	int left = right - (i - 2);      
	for (j = 0; j < i; j++) {	  
	  int lnode = att - i - j;
	  int rnode = att - i - j + 1;
	  if ((lnode >= 0) && (rnode >= 0) && (lnode >= left) && (rnode <= right)) {
	    if (vec[lnode] > vec[rnode]) { vec[att - j] += vec[lnode]; }
	    else { vec[att - j] += vec[rnode]; }
	  }
	  else if ((rnode >= 0) && (rnode <= right)) {
	    vec[att - j] += vec[rnode];
	  }
	  else if ((lnode >= 0) && (lnode >= left)) {
	    vec[att - j] += vec[lnode];
	  }
	  else {
	    if (vec[left] > vec[right]) { vec[att] += vec[left]; }
	    else { vec[att - j] += vec[right]; }
	  }
	  if (result < vec[att -j]) { result = vec[att - j]; } 
	}
      }
    }
    return result;
  }
};

int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  string in1 = "3 7 4 2 4 6 8 5 9 3";
  string in2 = "75 95 64 17 47 82 18 35 87 10 20 04 82 47 65 19 01 23 75 03 34 88 02 77 73 07 63 67 99 65 04 28 06 16 70 92 41 41 26 56 83 40 80 70 33 41 48 72 33 47 32 37 16 94 29 53 71 44 65 25 43 91 52 97 51 14 70 11 33 28 77 73 17 78 39 68 17 57 91 71 52 38 17 14 91 43 58 50 27 29 48 63 66 04 68 89 53 67 30 73 16 69 87 40 31 04 62 98 27 23 09 70 98 73 93 38 53 60 04 23";
  result = obj.solve(in2, 2);
  cout << result << endl;
  return 0;
}

