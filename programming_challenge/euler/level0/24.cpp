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
  
  int solve(int num) {
    int result = 0;
    int i,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9 = 0;
    int count = 0;
    for (c0 = 0; c0 <= 9; c0++) {
      int arr[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
      arr[c0] = 1;
      for (c1 = 0; c1 <= 9; c1++) {
	if (arr[c1] == 1) {} else { arr[c1] = 1;
	  for (c2 = 0; c2 <= 9; c2++) {
	    if (arr[c2] == 1) {} else { arr[c2] = 1;
	      for (c3 = 0; c3 <= 9; c3++) {
		if (arr[c3] == 1) {} else { arr[c3] = 1;
		  for (c4 = 0; c4 <= 9; c4++) {
		    if (arr[c4] == 1) {} else { arr[c4] = 1;
		      for (c5 = 0; c5 <= 9; c5++) {
			if (arr[c5] == 1) {} else { arr[c5] = 1;
			  for (c6 = 0; c6 <= 9; c6++) {
			    if (arr[c6] == 1) {} else { arr[c6] = 1;
			      for (c7 = 0; c7 <= 9; c7++) {
				if (arr[c7] == 1) {} else { arr[c7] = 1;
				  for (c8 = 0; c8 <= 9; c8++) {
				    if (arr[c8] == 1) {} else { arr[c8] = 1;
				      for (c9 = 0; c9 <= 9; c9++) {
					if (arr[c9] == 1) {} else {
					  count++;
					  if (count == num) {
					    cout <<c0<<c1<<c2<<c3<<c4<<c5<<c6<<c7<<c8<<c9<< endl;
					  }
					}
				      }
				      arr[c8] = 0;
				    }
				  }
				  arr[c7] = 0;
				}
			      }
			      arr[c6] = 0;
			    }
			  }
			  arr[c5] = 0;
			}
		      }
		      arr[c4] = 0;
		    }
		  }
		  arr[c3] = 0;
		}
	      }
	      arr[c2] = 0;
	    }
	  }
	  arr[c1] = 0;
	}
      }
    }
    return result;
  }

  int solve2(int num) {
    int result = 0;
    int i,c0,c1,c2 = 0;
    int count = 0;
    for (c0 = 0; c0 <= 2; c0++) {
      int arr[] = {0, 0, 0};
      arr[c0] = 1;
      for (c1 = 0; c1 <= 2; c1++) {
	if (1 == arr[c1]) {}
	else {
	  arr[c1] = 1;
	  for (c2 = 0; c2 <= 2; c2++) {
	    if (1 == arr[c2]) {}
	    else {
	      count++;
	      cout <<c0<<c1<<c2<< endl;
	      if (count == num) {
		cout <<c0<<c1<<c2<< endl;
	      }
	    }
	  }
	  arr[c1] = 0;
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

