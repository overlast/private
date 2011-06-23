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
   
  int is_palindrome (int num) {
    int result = 1;
    int i = 0;
    vector <int> vec;
    while (num > 0) {
      int amari = num % 10;
      vec.push_back(amari);
      num = num / 10;
    }
    for (i = 0; i < (vec.size() / 2); i++) {
      if (vec[i] == vec[vec.size() - 1 - i]) {}
      else { result = 0; }
    }
    return result;
  }

  int solve(int max) {
    int result = 0;
    int i, j = 0;
    int num = 0;
    int min = 0;       
    for (i = max; i > 0; i--) {      
      for (j = max; j > 0; j--) {
	num = i * j;
	if (num <= min) { break; } 
	if (1 == is_palindrome(num)) {
	  min = num;
	  result = min;
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
