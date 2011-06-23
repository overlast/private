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
  
  int solve(int num, int buf) {
    int result = 0;
    int i = 0;
    vector <int> vec;
    
    for (i = 0; i < buf; i++) {
      vec.push_back(0);
    }
    cout << "init" << endl;
    for (i = 1; i < num; i++) {
      if (1 == i) { vec[0] = 1; vec[i] = 1; result = 1; }
      if (vec[i] > 0){ 
	vec[i * 2] = (vec[i] + 1);
	if (result < (vec[i] + 1)) { result = vec[i] + 1;} 
      }
      else {
	//cout << "hoho";
	int focus = i;
	vector <int> tmp;
	while (0 == vec[focus]) {
	  //cout << focus << "<-";
	  tmp.push_back(focus);
	  if (0 == (focus % 2)) {
	    focus = focus / 2; 
	  }
	  else {
	    focus = (3 * focus) + 1;
	  }
	  //  cout << focus << ",";
	}
	//cout << endl;
	if (tmp.size() > 0) {
	  int j = 0;
	  int count = vec[focus];
	  //cout << focus << "focus" << vec[focus] <<endl;
	  for (j = tmp.size() - 1; j >= 0; j--) {
	    //cout << tmp[j] << ",";
	    count++;
	    vec[tmp[j]] = count;
	  }
	  //cout << endl;
	  if (result < count) { result = count;} 
	}
      }
    }

    //for (i = 0; i < buf; i++) {
      // cout << vec[i] << ":";
    //}
    //cout << endl;
    return result;
  }
};

int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  int num = atoi(argv[1]);
  int buf = atoi(argv[2]);
  result = obj.solve(num, buf);
  cout << result << endl;
  return 0;
}

