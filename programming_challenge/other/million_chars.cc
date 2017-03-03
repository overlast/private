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

  int get_digit(int num) {
    int res = 0;
    while (num > 0) {
      res++;
      num /= 10;
    }
    return res;
  }

  char solve(int query, int num) {
    char result = '\0';
    vector <int> prime_vec = get_prime_vec(num);
    int total = 0;
    char* str = (char*)malloc(sizeof(char) * get_digit(query));
    for (int i = 2; i <= num; i++) {
      if (1 != prime_vec[i]) { continue; }
      int digit = get_digit(i);
      if (total + digit < query) {
        total += digit;
      } else {
        int diff = total + digit - query;
        sprintf(str, "%d", i);
        result = str[digit - diff - 1];
        break;
      }
    }
    return result;
  }
};

int main(int argc, char *argv[]) {
  char result = '\0';
  Solution obj;
  int num1 = atoi(argv[1]);
  int num2 = atoi(argv[2]);
  result = obj.solve(num1, num2);
  cout << result << endl;
  return 0;
}
