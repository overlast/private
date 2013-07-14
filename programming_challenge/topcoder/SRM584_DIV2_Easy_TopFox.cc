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

#define forall(i,a,b)               for(int i=a;i<(int)b;i++)

class TopFox {
public:
  int possibleHandles(string familyName, string givenName) {
    int res = 0;
    set<string> hash;
    forall(i, 1, familyName.length() + 1) {
      forall(j, 1, givenName.length() + 1) {
        string cand = familyName.substr(0, i) + givenName.substr(0, j);
        if (hash.find(cand) == hash.end()){
          hash.insert(cand);
        }
      }
    }
    res = hash.size();
    return res;
  }


// BEGIN CUT HERE
	public:
	void run_test(int Case) { if ((Case == -1) || (Case == 0)) test_case_0(); if ((Case == -1) || (Case == 1)) test_case_1(); if ((Case == -1) || (Case == 2)) test_case_2(); if ((Case == -1) || (Case == 3)) test_case_3(); if ((Case == -1) || (Case == 4)) test_case_4(); if ((Case == -1) || (Case == 5)) test_case_5(); }
	private:
	template <typename T> string print_array(const vector<T> &V) { ostringstream os; os << "{ "; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << '\"' << *iter << "\","; os << " }"; return os.str(); }
	void verify_case(int Case, const int &Expected, const int &Received) { cerr << "Test Case #" << Case << "..."; if (Expected == Received) cerr << "PASSED" << endl; else { cerr << "FAILED" << endl; cerr << "\tExpected: \"" << Expected << '\"' << endl; cerr << "\tReceived: \"" << Received << '\"' << endl; } }
	void test_case_0() { string Arg0 = "ab"; string Arg1 = "cd"; int Arg2 = 4; verify_case(0, Arg2, possibleHandles(Arg0, Arg1)); }
	void test_case_1() { string Arg0 = "abb"; string Arg1 = "bbc"; int Arg2 = 7; verify_case(1, Arg2, possibleHandles(Arg0, Arg1)); }
	void test_case_2() { string Arg0 = "fox"; string Arg1 = "ciel"; int Arg2 = 12; verify_case(2, Arg2, possibleHandles(Arg0, Arg1)); }
	void test_case_3() { string Arg0 = "abbbb"; string Arg1 = "bbbbbbbc"; int Arg2 = 16; verify_case(3, Arg2, possibleHandles(Arg0, Arg1)); }
	void test_case_4() { string Arg0 = "abxy"; string Arg1 = "xyxyxc"; int Arg2 = 21; verify_case(4, Arg2, possibleHandles(Arg0, Arg1)); }
	void test_case_5() { string Arg0 = "ababababab"; string Arg1 = "bababababa"; int Arg2 = 68; verify_case(5, Arg2, possibleHandles(Arg0, Arg1)); }

// END CUT HERE

};

// BEGIN CUT HERE
int main() {
  TopFox ___test;
  ___test.run_test(-1);
}
// END CUT HERE
