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
#include <stdlib.h>
using namespace std;
static const double EPS = 1e-5;
typedef long long ll;

class SwappingDigits {
public:
  string minNumber(string num) {
    cout << num << endl;

    string result;
    int N = num.length();
    for (int i = 0; i < N - 1; i++) {
      char min_num = '\0';
      int min_att = -1;
      if ((num[i] == '0') || ((i == 0) && (num[i] == '1'))) {
        continue;
      }
      for (int j = i + 1; j < N; j++) {
        if (min_num == '\0') {
          if (num[i] > num[j]) {
            if ((i == 0) && (num[j] == '0')){
            } else {
              min_num = num[j];
              min_att = j;
            }
          }
        }else {
          if (num[min_att] >= num[j]) {
            if ((i == 0) && (num[j] == '0')){
            } else {
              min_num = num[j];
              min_att = j;
            }
          }
        }
      }
      if ((min_num != '\0') && (((i == 0) && (num[min_att] != '0')) || (i != 0))) {
        char tmp = num[i];
        num[i] = num[min_att];
        cout << num << endl;
        num[min_att] = tmp;
        cout << num << endl;

        break;
      } else {
        min_num = '\0';
        min_att = -1;
      }
    }
    result = num;
    return result;
  }


// BEGIN CUT HERE
	public:
	void run_test(int Case) { if ((Case == -1) || (Case == 0)) test_case_0(); if ((Case == -1) || (Case == 1)) test_case_1(); if ((Case == -1) || (Case == 2)) test_case_2(); if ((Case == -1) || (Case == 3)) test_case_3(); if ((Case == -1) || (Case == 4)) test_case_4(); if ((Case == -1) || (Case == 5)) test_case_5(); if ((Case == -1) || (Case == 6)) test_case_6(); };

	private:
	template <typename T> string print_array(const vector<T> &V) { ostringstream os; os << "{ "; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << '\"' << *iter << "\","; os << " }"; return os.str(); }
	void verify_case(int Case, const string &Expected, const string &Received) { cerr << "Test Case #" << Case << "..."; if (Expected == Received) cerr << "PASSED" << endl; else { cerr << "FAILED" << endl; cerr << "\tExpected: \"" << Expected << '\"' << endl; cerr << "\tReceived: \"" << Received << '\"' << endl; } }
	void test_case_0() { string Arg0 = "596"; string Arg1 = "569"; verify_case(0, Arg1, minNumber(Arg0)); }
	void test_case_1() { string Arg0 = "93561"; string Arg1 = "13569"; verify_case(1, Arg1, minNumber(Arg0)); }
	void test_case_2() { string Arg0 = "5491727514"; string Arg1 = "1491727554"; verify_case(2, Arg1, minNumber(Arg0)); }
	void test_case_3() { string Arg0 = "10234"; string Arg1 = "10234"; verify_case(3, Arg1, minNumber(Arg0)); }
	void test_case_4() { string Arg0 = "93218910471211292416"; string Arg1 = "13218910471211292496"; verify_case(4, Arg1, minNumber(Arg0)); }
  void test_case_5() { string Arg0 = "1297866953311623818166341429500"; string Arg1 = "1097866953311623818166341429502"; verify_case(5, Arg1, minNumber(Arg0)); }
  void test_case_6() { string Arg0 = "33333333333333333333478477835743436664644"; string Arg1 = "33333333333333333333378477835743446664644"; verify_case(6, Arg1, minNumber(Arg0)); }
// END CUT HERE

};

// BEGIN CUT HERE
int main() {
  SwappingDigits ___test;
  ___test.run_test(-1);
}
// END CUT HERE
