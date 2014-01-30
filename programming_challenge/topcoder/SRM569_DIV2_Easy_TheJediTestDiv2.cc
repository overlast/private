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

class TheJediTestDiv2 {
public:
  int countSupervisors(vector <int> students, int Y, int J) {
    int res = 60000;
    sort(students.begin(), students.end());
    forall(i, 0, students.size()) {
      int tmp = 0;
      forall(j, 0, students.size()) {
        if (students[j] > 0) {
          if (j != i) {
            tmp = tmp + ((students[j] + J - 1) / J);
          } else if ((students[j] - Y) > 0) {
            tmp = tmp + ((students[j] - Y  + J - 1) / J);
          }
        }
      }
      res = min(res, tmp);
    }
    return res;
  }


// BEGIN CUT HERE
	public:
	void run_test(int Case) { if ((Case == -1) || (Case == 0)) test_case_0(); if ((Case == -1) || (Case == 1)) test_case_1(); if ((Case == -1) || (Case == 2)) test_case_2(); if ((Case == -1) || (Case == 3)) test_case_3(); if ((Case == -1) || (Case == 4)) test_case_4(); if ((Case == -1) || (Case == 5)) test_case_5(); }
	private:
	template <typename T> string print_array(const vector<T> &V) { ostringstream os; os << "{ "; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << '\"' << *iter << "\","; os << " }"; return os.str(); }
	void verify_case(int Case, const int &Expected, const int &Received) { cerr << "Test Case #" << Case << "..."; if (Expected == Received) cerr << "PASSED" << endl; else { cerr << "FAILED" << endl; cerr << "\tExpected: \"" << Expected << '\"' << endl; cerr << "\tReceived: \"" << Received << '\"' << endl; } }
	void test_case_0() { int Arr0[] = {10, 15}; vector <int> Arg0(Arr0, Arr0 + (sizeof(Arr0) / sizeof(Arr0[0]))); int Arg1 = 12; int Arg2 = 5; int Arg3 = 3; verify_case(0, Arg3, countSupervisors(Arg0, Arg1, Arg2)); }
	void test_case_1() { int Arr0[] = {11, 13, 15}; vector <int> Arg0(Arr0, Arr0 + (sizeof(Arr0) / sizeof(Arr0[0]))); int Arg1 = 9; int Arg2 = 5; int Arg3 = 7; verify_case(1, Arg3, countSupervisors(Arg0, Arg1, Arg2)); }
	void test_case_2() { int Arr0[] = {10}; vector <int> Arg0(Arr0, Arr0 + (sizeof(Arr0) / sizeof(Arr0[0]))); int Arg1 = 100; int Arg2 = 2; int Arg3 = 0; verify_case(2, Arg3, countSupervisors(Arg0, Arg1, Arg2)); }
	void test_case_3() { int Arr0[] = {0, 0, 0, 0, 0}; vector <int> Arg0(Arr0, Arr0 + (sizeof(Arr0) / sizeof(Arr0[0]))); int Arg1 = 145; int Arg2 = 21; int Arg3 = 0; verify_case(3, Arg3, countSupervisors(Arg0, Arg1, Arg2)); }
	void test_case_4() { int Arr0[] = {4, 7, 10, 5, 6, 55, 2}; vector <int> Arg0(Arr0, Arr0 + (sizeof(Arr0) / sizeof(Arr0[0]))); int Arg1 = 20; int Arg2 = 3; int Arg3 = 26; verify_case(4, Arg3, countSupervisors(Arg0, Arg1, Arg2)); }
	void test_case_5() { int Arr0[] = {
      45, 551, 575, 17, 90, 488, 22, 195, 278, 659, 36, 251, 663, 341, 129, 6, 481, 398, 778, 360, 297, 545, 869, 798, 739, 684, 711, 928, 986, 85, 885, 586, 723, 341, 453, 552, 507, 123, 648, 920, 573, 956, 919, 739, 963, 391, 385
          }; vector <int> Arg0(Arr0, Arr0 + (sizeof(Arr0) / sizeof(Arr0[0]))); int Arg1 = 201; int Arg2 = 194; int Arg3 = 143; verify_case(5, Arg3, countSupervisors(Arg0, Arg1, Arg2)); }

// END CUT HERE

};

// BEGIN CUT HERE
int main() {
  TheJediTestDiv2 ___test;
  ___test.run_test(-1);
}
// END CUT HERE
