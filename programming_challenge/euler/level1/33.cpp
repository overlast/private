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
    string str = "";
    stringstream ss;
    ss << num;
    ss >> str;
    return str;
  }
  
  double get_curious(int n1, int n2) {
    double res = 0.0;
    string str1 = itos(n1);
    string str2 = itos(n2);
    int c10 = str1[0];
    int c11 = str1[1];
    int c20 = str2[0];
    int c21 = str2[1];
    c10 -= 48; c11 -= 48; c20 -= 48; c21 -= 48;
    if (c10 == c20) { res = (double)c11/(double)c21; }
    else if (c10 == c21) { res = (double)c11/(double)c20; }
    else if (c11 == c20) { res = (double)c10/(double)c21; }
    else if (c11 == c21) { res = (double)c10/(double)c20; }
    return res;
  }
  
  int solve(void) {
    int result = 0;
    int numerator = 1;
    int denominator = 1;
    for (int i = 10; i < 100; i++) {
      if (0 == i % 10) { continue; }
      if (0 == i % 11) { continue; }
      for (int j = 10; j < 100; j++) {
	if (0 == j % 10) { continue; }
	if (0 == j % 11) { continue; }
	if (i > j) { continue; }
	if (i == j) { continue; }
	double curious = get_curious(i, j);
	double base = (double)i / (double)j;
	if (base == curious) {
	  cout << i << ":" << j << endl;
	  numerator *= i;
	  denominator *= j;
	}
      }
    }
    cout << numerator << ":" << denominator << endl;
    for (int i = 2; i <= numerator; i++) {
      while ((0 == numerator % i) && (0 == denominator % i)) {
	numerator /= i;
	denominator /= i;
	cout << i << ":" << numerator << ":" << denominator << endl;
      }
    }
    if (denominator > 0) { result = denominator; }
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

