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
  
  vector <int> get_prime_vec(int num) {
    vector <int> vec;
    for (int i = 0; i <= num; i++) {
      if (0 == i % 2) { vec.push_back(0); }
      else { vec.push_back(1); }      
    }
    if (num > 0) {
      vec[1] = 0;
      if (num > 1) {
	vec[2] = 1;
	for (int j = 3; j <= num; j += 2) {
	  if (1 == vec[j]) {
	    for (int k = j + j; k <= num; k += j) {
	      vec[k] = 0;
	    }
	  }
	}
      }
    }
    return vec;
  }

  int get_diver(int num) {
    int res = 1;
    while (res * 10 < num) {
      res *= 10;
    }
    return res;
  }

  vector <int> is_family(int num, int famiry) {
    vector <int> vec;
    int arr[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    int arr_size = sizeof(arr) / sizeof(int);
    num /= 10;
    while (num > 0) {
      arr[num % 10]++;
      num /= 10;
    }
    for (int i = 0; i < arr_size; i++) {
      if (arr[i] == famiry) {
	vec.push_back(i);
      }
    }
    return vec;
  }
  
  int get_gigit(int num) {
    int res = 0;
    while (num > 0) {
      res++;
      num /= 10;
    }
    return res;
  }

  int solve(int num, int famiry) {
    int result = 0;
    vector <int> prime_vec = get_prime_vec(num);
    
    map <int, string> mis = get_masked_map(prime_vec, );
    
    return result;
  }
};


int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int num1 = atoi(argv[1]);
  int num2 = atoi(argv[2]);
  result = obj.solve(num1, num2);
  cout << result << endl;
  return 0;
}

