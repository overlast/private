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

// Useful container manipulation / traversal macros
#define forall(i,a,b)               for(int i=a;i<(int)b;i++)

class TrafficCongestionDivTwo {
public:
  ll theMinCars(int treeHeight) {
    vector<ll> ans;
    ans.push_back(1);
    forall (i, 1, treeHeight+1) {
      ll tmp = 1;
      forall (j, 1, i+1) {
        if (j - 2 >= 0) {
          tmp = tmp + (ans[j - 2] * 2);
        }
      }
      ans.push_back(tmp);
    }
    return ans[treeHeight];
  }


// BEGIN CUT HERE
	public:
	void run_test(int Case) { if ((Case == -1) || (Case == 0)) test_case_0(); if ((Case == -1) || (Case == 1)) test_case_1(); if ((Case == -1) || (Case == 2)) test_case_2(); if ((Case == -1) || (Case == 3)) test_case_3(); if ((Case == -1) || (Case == 4)) test_case_4(); }
	private:
	template <typename T> string print_array(const vector<T> &V) { ostringstream os; os << "{ "; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << '\"' << *iter << "\","; os << " }"; return os.str(); }
	void verify_case(int Case, const ll &Expected, const ll &Received) { cerr << "Test Case #" << Case << "..."; if (Expected == Received) cerr << "PASSED" << endl; else { cerr << "FAILED" << endl; cerr << "\tExpected: \"" << Expected << '\"' << endl; cerr << "\tReceived: \"" << Received << '\"' << endl; } }
	void test_case_0() { int Arg0 = 1; ll Arg1 = 1LL; verify_case(0, Arg1, theMinCars(Arg0)); }
	void test_case_1() { int Arg0 = 2; ll Arg1 = 3LL; verify_case(1, Arg1, theMinCars(Arg0)); }
	void test_case_2() { int Arg0 = 3; ll Arg1 = 5LL; verify_case(2, Arg1, theMinCars(Arg0)); }
	void test_case_3() { int Arg0 = 10; ll Arg1 = 683LL; verify_case(3, Arg1, theMinCars(Arg0)); }
	void test_case_4() { int Arg0 = 60; ll Arg1 = 768614336404564651LL; verify_case(4, Arg1, theMinCars(Arg0)); }

// END CUT HERE

};

// BEGIN CUT HERE
int main() {
  TrafficCongestionDivTwo ___test;
  ___test.run_test(-1);
}
// END CUT HERE
