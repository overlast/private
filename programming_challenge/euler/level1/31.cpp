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
  
  map < pair <int, int>, int > mpiii;

  int roop(int num, int pcoin) {
    int coins[] = {1, 2, 5, 10, 20, 50, 100, 200};
    int coin_num = sizeof(coins)/sizeof(int);
    int result = 0;
    map < pair <int, int>, int >::iterator it;
    it = mpiii.find(pair<int, int>(num, pcoin));
    if (it == mpiii.end()) {
      for (int i = pcoin; i < coin_num; i++) {
	int tnum = num;
	for (int j = 1; num >= (coins[i] * j); j++) {
	  //cout << i << ":" << coins[i] << ":" << j << ":" << tnum << endl;
	  tnum = num - (coins[i] * j);
	  if (0 == tnum ) { result++; }
	  else if (0 > tnum) { break; }
	  else { result += roop(tnum, i + 1); }
	}
      }
      mpiii[pair<int, int>(num, pcoin)] = result;
    }
    else {
      result = (*it).second;
    }
    return result;
  }

  int solve(int num) {
    int result = roop(num, 0);
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


