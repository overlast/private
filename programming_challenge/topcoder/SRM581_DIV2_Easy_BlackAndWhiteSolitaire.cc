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
    int N = cardFront.size();
    vector<int> org(N), bf(N), wf(N);
    int bf_count = 0;
    int wf_count = 0;
    for (int i = 0; i < N; i++) {
      if (cardFront[i] == 'B') {
        org[i] = 1;
      } else {
        org[i] = 0;
      }
    }
    bf[0] = 1;
    wf[0] = 0;
    for (int i = 1; i < N; i++) {
      bf[i] = !bf[i - 1];
      wf[i] = !wf[i - 1];
    }
    for (int i = 0; i < N; i++) {
      if (bf[i] != org[i]) {
        bf_count++;
      }
      if (wf[i] != org[i]) {
        wf_count++;
      }
    }
    result = min(bf_count, wf_count);
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
