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
#include <fstream>
#include <iostream>
using namespace std;
static const double EPS = 1e-5;
typedef long long ll;
typedef unsigned int uint;

class Solution {
  
public:

  vector <string> make_vec (string str) {
    vector <string> vec;
    int i = 0;
    int left = -1;
    int right = 0;
    bool is_find = false;
    while (i < str.size()) {
      if (str[i] == '"') {
	if (left == right) { right = i; is_find = true; }
	else { left = i; right = left;}
      }
      if (is_find) {
        string tmp =  str.substr(left + 1, right - left - 1);
	vec.push_back(tmp);
	is_find = false;
      }
      i++;
    }
    return vec;
  }

  int solve(string str) {
    int result = 0;
    int i, j = 0;
    vector <string> vec = make_vec(str);
    sort(vec.begin(), vec.end());
    for (i = 0; i < vec.size(); i++) {
      //cout << vec[i] << " : ";
      for (j = 0; j < vec[i].size(); j++ ) {
	int c = vec[i][j];
	c = c - 64;
	//cout << c << ",";
	result = result + c * (i + 1);
      }
      //cout << endl;
    }
    return result;
  }
};

int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;
  char* file = strdup(argv[1]);
  string buf;
  ifstream ifs(file);
  while(ifs && getline(ifs, buf)) {
    //cout << buf << endl;
    result = obj.solve(buf);
    cout << result << endl;
  }
  return 0;
}

