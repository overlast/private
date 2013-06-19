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

class EllysNewNickname {
public:
  int getLength(string nickname) {
    int result = 0;
    int len = nickname.length();
    bool is_no_v = true;
    for (int i = 0; i < len; i++) {
      char c = nickname[i];
      if ( (c == 'a') || (c == 'i') || (c == 'u') || (c == 'e') || (c == 'o') || (c == 'y') ) {
        if (is_no_v) {
          result++;
          is_no_v = false;
        }
      } else {
        is_no_v = true;
        result++;
      }
    }
    return result;
  }


// BEGIN CUT HERE
	public:
	void run_test(int Case) { if ((Case == -1) || (Case == 0)) test_case_0(); if ((Case == -1) || (Case == 1)) test_case_1(); if ((Case == -1) || (Case == 2)) test_case_2(); if ((Case == -1) || (Case == 3)) test_case_3(); if ((Case == -1) || (Case == 4)) test_case_4(); if ((Case == -1) || (Case == 5)) test_case_5(); }
	private:
	template <typename T> string print_array(const vector<T> &V) { ostringstream os; os << "{ "; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << '\"' << *iter << "\","; os << " }"; return os.str(); }
	void verify_case(int Case, const int &Expected, const int &Received) { cerr << "Test Case #" << Case << "..."; if (Expected == Received) cerr << "PASSED" << endl; else { cerr << "FAILED" << endl; cerr << "\tExpected: \"" << Expected << '\"' << endl; cerr << "\tReceived: \"" << Received << '\"' << endl; } }
	void test_case_0() { string Arg0 = "tourist"; int Arg1 = 6; verify_case(0, Arg1, getLength(Arg0)); }
	void test_case_1() { string Arg0 = "eagaeoppooaaa"; int Arg1 = 6; verify_case(1, Arg1, getLength(Arg0)); }
	void test_case_2() { string Arg0 = "esprit"; int Arg1 = 6; verify_case(2, Arg1, getLength(Arg0)); }
	void test_case_3() { string Arg0 = "ayayayayayaya"; int Arg1 = 1; verify_case(3, Arg1, getLength(Arg0)); }
	void test_case_4() { string Arg0 = "wuuut"; int Arg1 = 3; verify_case(4, Arg1, getLength(Arg0)); }
	void test_case_5() { string Arg0 = "naaaaaaaanaaaanaananaaaaabaaaaaaaatmaaaaan"; int Arg1 = 16; verify_case(5, Arg1, getLength(Arg0)); }

// END CUT HERE

};

// BEGIN CUT HERE
int main() {
  EllysNewNickname ___test;
  ___test.run_test(-1);
}
// END CUT HERE
