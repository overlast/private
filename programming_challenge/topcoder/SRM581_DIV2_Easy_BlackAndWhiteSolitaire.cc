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

class BlackAndWhiteSolitaire {
public:
  int minimumTurns(string cardFront) {
    int result = 0;
    int ki_b = 0;
    int ki_w = 0;
    int gu_b = 0;
    int gu_w = 0;
    bool is_ki_w_case = true;
    for (int i = 0; i < cardFront.size(); i++) {
      if ((i % 2) == 0) {
        if (cardFront[i] == 'W') {
          gu_w++;
        } else {
          gu_b++;
        }
      } else {
        if (cardFront[i] == 'W') {
          ki_w++;
        } else {
          ki_b++;
        }
      }
    }

    if ((ki_b >= ki_w ) && (gu_w >= gu_b)) {
      is_ki_w_case = false;
    } else {
      if (gu_w > ki_w) {
        is_ki_w_case = false;
      }
    }

    for (int i = 0; i < cardFront.size(); i++) {
      if (is_ki_w_case) {
        if ((i % 2) == 0) {
          if (cardFront[i] == 'W') {
            result++;
          }
        } else {
          if (cardFront[i] == 'B') {
            result++;
          }
        }
      } else {
        if ((i % 2) == 0) {
          if (cardFront[i] == 'B') {
            result++;
          }
        } else {
          if (cardFront[i] == 'W') {
            result++;
          }
        }
      }
    }

    return result;
  }


// BEGIN CUT HERE
	public:
	void run_test(int Case) { if ((Case == -1) || (Case == 0)) test_case_0(); if ((Case == -1) || (Case == 1)) test_case_1(); if ((Case == -1) || (Case == 2)) test_case_2(); if ((Case == -1) || (Case == 3)) test_case_3(); if ((Case == -1) || (Case == 4)) test_case_4(); }
	private:
	template <typename T> string print_array(const vector<T> &V) { ostringstream os; os << "{ "; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << '\"' << *iter << "\","; os << " }"; return os.str(); }
	void verify_case(int Case, const int &Expected, const int &Received) { cerr << "Test Case #" << Case << "..."; if (Expected == Received) cerr << "PASSED" << endl; else { cerr << "FAILED" << endl; cerr << "\tExpected: \"" << Expected << '\"' << endl; cerr << "\tReceived: \"" << Received << '\"' << endl; } }
	void test_case_0() { string Arg0 = "BBBW"; int Arg1 = 1; verify_case(0, Arg1, minimumTurns(Arg0)); }
	void test_case_1() { string Arg0 = "WBWBW"; int Arg1 = 0; verify_case(1, Arg1, minimumTurns(Arg0)); }
	void test_case_2() { string Arg0 = "WWWWWWWWW"; int Arg1 = 4; verify_case(2, Arg1, minimumTurns(Arg0)); }
	void test_case_3() { string Arg0 = "BBWBWWBWBWWBBBWBWBWBBWBBW"; int Arg1 = 10; verify_case(3, Arg1, minimumTurns(Arg0)); }
  void test_case_4() { string Arg0 = "BBWWWWWWBW"; int Arg1 = 4; verify_case(4, Arg1, minimumTurns(Arg0));}
  // END CUT HERE

};

// BEGIN CUT HERE
int main() {
  BlackAndWhiteSolitaire ___test;
  ___test.run_test(-1);
}
// END CUT HERE
