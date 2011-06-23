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
    int digit = get_gigit(num);
    for (int i = 3; i <= digit; i++) {
      for (int j = 2; j <= num; j++) {
	if (1 != prime_vec[j]) { continue; }
	int diver = 0;
	vector <int> key_vec = is_family(j, i);
	if (key_vec.size() < 0 ) { continue; }
	for (int k = 0; k < key_vec.size(); k++) {
	  int change_counter = 0;	
	  int change_num = 0;
	  for (int l = 0; l < 9; l++) {
	    int tmp = j;
	    int keta = 1;
	    int amari = tmp % 10;
	    change_num = amari;
	    tmp /= 10;
	    keta *= 10;
	    while (tmp > 0) {
	      amari = tmp % 10;
	      if (amari == key_vec[k]) {
		change_num += l * keta;
	      }
	      else {
		change_num += amari * keta;
	      }
	      tmp /= 10;
	      keta *= 10;
	    }
	    if (change_num <= j) { continue ;}
	    if (change_num > num) { continue; }
	    if (1 != prime_vec[change_num]) { continue; }
	    if (result == 0)  {
	      result = j;
	    }
	    change_counter++;
	  }
	  if (change_counter >= famiry) { break; }
	  result = 0;
	}
	if (result > 0) { break;}
      }
      if (result > 0) { break;}
    }
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

