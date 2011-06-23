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

  vector <string> get_tani_vec (void) {
    vector <string> vec;
    vec.push_back("thousand");
    vec.push_back("million");
    vec.push_back("billion");
    vec.push_back("trillion");
    vec.push_back("quadrillion");    
    return vec;

  }
  
  string get_one_to_nine(int num) {
    string result = "";
    switch(num) {    
    case 0:
      result = "zero"; break;
    case 1:
      result = "one"; break;
    case 2:
      result = "two"; break;
    case 3:
      result = "three"; break;
    case 4:
      result = "four"; break;
    case 5:
      result = "five"; break;
    case 6:
      result = "six"; break;
    case 7:
      result = "seven"; break;
    case 8:
      result = "eight"; break;
    case 9:
      result = "nine"; break;
    }
    return result;
  }
  
  string get_teen(int num) {
    string result = "";
    num = num % 10;
    switch(num) {    
    case 0:
      result = "ten"; break;
    case 1:
      result = "eleven"; break;
    case 2:
      result = "twelve"; break;
    case 3:
      result = "thirteen"; break;
    case 4:
      result = "fourteen"; break;
    case 5:
      result = "fifteen"; break;
    case 6:
      result = "sixteen"; break;
    case 7:
      result = "seventeen"; break;
    case 8:
      result = "eighteen"; break;
    case 9:
      result = "nineteen"; break;
    }
    return result;
  }

  string get_ty(int num) {
    string result = "";
    int tmp = num % 10;
    string shimo = get_one_to_nine(tmp);
    num = num / 10;
    switch(num) {    
    case 2:
      result = "twenty"; break;
    case 3:
      result = "thirty"; break;
    case 4:
      result = "forty"; break;
    case 5:
      result = "fifty"; break;
    case 6:
      result = "sixty"; break;
    case 7:
      result = "seventy"; break;
    case 8:
      result = "eighty"; break;
    case 9:
      result = "ninety"; break;
    }
    if (0 == tmp) {
      result = result;
    }
    else {
      result = result + " " + shimo;
    }
    return result;
  }

  string solve(int num) {
    string result = "";
    vector <string> tani = get_tani_vec();
    int tani_count = 0;    
    int turn = 0;

    if (0 == num) {
      result = get_one_to_nine(num);
    }
    else {
      int t_count = 0;
      int niketa = 0;
      while (num > 0) {
	if (tani_count >= 3) { 
	  if (num % 1000 > 0) {
	    if ((result.compare(0, result.size(), "") == 0)) {
	      result = tani[t_count];
	    }
	    else {
	      result = tani[t_count] + " and " + result;
	    }
	  }
	  tani_count = 0;
	  t_count++;
	}
	else { tani_count++; }

	if (turn == 0) {
	  turn = 1;

	  string niketa_buf = "";
	  niketa = num % 100;
	  if (num > 9) {
	    num = num / 100;
	    if (niketa >= 20) {
	      niketa_buf = get_ty(niketa);
	    }
	    else if (niketa >= 10) {
	      niketa_buf = get_teen(niketa);
	    }
	    else {
	      if (0 != niketa) {
		niketa_buf = get_one_to_nine(niketa);
	      }
	    }
	    tani_count++;
	  }
	  else {
	    niketa_buf = get_one_to_nine(niketa);
	    num = -1;
	  }

	  if (result == "") { result = niketa_buf; }
	  else { result = niketa_buf + " " + result; }

	}      
	else {
	  turn = 0;

	  if (num > 0) {
	    int hitoketa = num % 10;
	    num = num / 10;

	    if (hitoketa > 0) { 
	      if (0 == niketa) { result = "hundred" + result; }
	      else {result = "hundred and " + result; }
	      if (0 != hitoketa) { 
		string hitoketa_buf = get_one_to_nine(hitoketa);
		result = hitoketa_buf + " " + result;	  
	      }
	    }
	  }
	}
      }
    }
    return result;
  }

};

int main(int argc, char *argv[]) {
  string result = "";
  Solution obj;
  int start = atoi(argv[1]);
  int end = atoi(argv[2]);
  int i, j, c = 0;
  for (i = start; i <= end; i++) { 
    result = obj.solve(i);
    cout << result << endl;
    for (j = 0; j < result.size(); j++) {
      if ((result.compare(j, 1, " ") != 0) && (result.compare(j, 1, "-") != 0)) {
	c++;
      }
    }
  }
  cout << c << endl;
  return 0;
}


