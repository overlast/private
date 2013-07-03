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
#define foreach(v, c)               for( typeof( (c).begin()) v = (c).begin();  v != (c).end(); ++v)

int stoi (string str) {
  stringstream ss;
  ss << str;
  int res = 0;
  ss >> res;
  return res;
}

class IDNumberVerification {
public:
  string verify(string id, vector <string> regionCodes) {
    string INV = "Invalid";
    string res = INV;
    /*
-id will be 18 characters long.
-First 17 characters of id will be between '0' and '9', inclusive.
-Last character of id will be 'X' or between '0' and '9', inclusive.
-regionCodes will contain between 1 and 50 elements, inclusive.
-Each element of regionCodes will be 6 characters long.
-Each element of regionCodes will consist of characters between '0' and '9', inclusive.
-For each element of regionCodes, its first character will not be '0'.
-Elements of regionCodes will be pairwise distinct.
     */
    if ((id.length() == 0) || (id.length() > 18)){
      return INV;
    }
    forall (i,0,id.length()) {
      if ((id[i] - '0' < 0) || (id[i] - '0' > 9)) {
        if ((i == ((int)id.length() - 1)) && (id[id.length() - 1] == 'X')) {
        } else {
          return INV;
        }
      }
    }
    forall(i, 0, regionCodes.size()) {
      if ((regionCodes[i].length() == 0) || (regionCodes[i].length() > 6)){
        return INV;
      }
      if (regionCodes[i][0] == 0) {
        return INV;
      }
      forall(j, 0, regionCodes[i].length()) {
        if ((regionCodes[i][j] - '0' < 0) || (regionCodes[i][j] - '0' > 9)) {
          return INV;
        }
      }
    }
    int is_valid_region = 0;
    forall (i, 0, regionCodes.size()) {
      if (regionCodes[i] == id.substr( 0, 6 )) {
        is_valid_region++;
      }
    }
    if (is_valid_region != 1) {
      return INV;
    }


    int ymd = stoi(id.substr( 6, 8 ));
    int year = stoi(id.substr( 6, 4 ));
    int mon = stoi(id.substr( 10, 2 ));
    int day = stoi(id.substr( 12, 2 ));

    if ((ymd < 19000101) || (ymd > 20111231)) {
      return INV;
    }
    if ((mon < 1) || (mon > 12)) {
      return INV;
    }
    if ((day < 1) || (day > 31)) {
      return INV;
    }
    if (day == 31) {
      if ((mon % 2 == 1) && (mon < 8)) {
      } else if ((mon % 2 == 0) && (mon > 7)){
      } else {
        return INV;
      }
    }
    if (mon == 2) {
      if (day == 30) {
        return INV;
      } else if (day == 29) {
        if ((year % 400 != 0) && ((year % 100 == 0) || (year % 4 != 0))) {
          return INV;
        }
      }
    }

    int x = 0;
    for (int i = 0; i < (int)id.length() - 1; i++ ) {
      x = (x + (id[i] - '0')) * 2;
    }
    if (id[id.length() - 1] == 'X') {
      x += 10;
    } else {
      x += id[id.length() -1] - '0';
    }

    if (x % 11 != 1) {
      return INV;
    }

    string code = id.substr( 14, 3 );
    if (code == "000") {
      return INV;
    }
    int code_num = stoi(code);
    if (code_num % 2 == 1) {
      res = "Male";
    } else {
      res = "Female";
    }

    return res;
  }


// BEGIN CUT HERE
	public:
	void run_test(int Case) { if ((Case == -1) || (Case == 0)) test_case_0(); if ((Case == -1) || (Case == 1)) test_case_1(); if ((Case == -1) || (Case == 2)) test_case_2(); if ((Case == -1) || (Case == 3)) test_case_3(); if ((Case == -1) || (Case == 4)) test_case_4(); if ((Case == -1) || (Case == 5)) test_case_5(); if ((Case == -1) || (Case == 6)) test_case_6(); if ((Case == -1) || (Case == 7)) test_case_7(); }
	private:
	template <typename T> string print_array(const vector<T> &V) { ostringstream os; os << "{ "; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << '\"' << *iter << "\","; os << " }"; return os.str(); }
	void verify_case(int Case, const string &Expected, const string &Received) { cerr << "Test Case #" << Case << "..."; if (Expected == Received) cerr << "PASSED" << endl; else { cerr << "FAILED" << endl; cerr << "\tExpected: \"" << Expected << '\"' << endl; cerr << "\tReceived: \"" << Received << '\"' << endl; } }
	void test_case_0() { string Arg0 = "441323200312060636"; string Arr1[] = {"441323"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Male"; verify_case(0, Arg2, verify(Arg0, Arg1)); }
	void test_case_1() { string Arg0 = "62012319240507058X"; string Arr1[] = {"620123"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Female"; verify_case(1, Arg2, verify(Arg0, Arg1)); }
	void test_case_2() { string Arg0 = "321669197204300886"; string Arr1[] = {"610111","659004"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Invalid"; verify_case(2, Arg2, verify(Arg0, Arg1)); }
	void test_case_3() { string Arg0 = "230231198306900162"; string Arr1[] = {"230231"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Invalid"; verify_case(3, Arg2, verify(Arg0, Arg1)); }
	void test_case_4() { string Arg0 = "341400198407260005"; string Arr1[] = {"341400"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Invalid"; verify_case(4, Arg2, verify(Arg0, Arg1)); }
	void test_case_5() { string Arg0 = "520381193206090891"; string Arr1[] = {"532922","520381"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Invalid"; verify_case(5, Arg2, verify(Arg0, Arg1)); }
  void test_case_6() { string Arg0 = "350425245406180780"; string Arr1[] = {"220401", "130533", "210900", "431002", "652700", "220181", "360401", "441781", "441481", "510823", "350425", "610327", "510722", "430901", "360822", "431101", "500118", "510703", "222424", "513425", "141182", "341723", "150206", "341103", "540100", "430702"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Invalid"; verify_case(6, Arg2, verify(Arg0, Arg1)); }
  void test_case_7() { string Arg0 = "530326191602290964"; string Arr1[] = {"320202", "331000", "411501", "120102", "530326", "361122", "610801"}; vector <string> Arg1(Arr1, Arr1 + (sizeof(Arr1) / sizeof(Arr1[0]))); string Arg2 = "Female"; verify_case(7, Arg2, verify(Arg0, Arg1)); }


// END CUT HERE

};

// BEGIN CUT HERE
int main() {
  IDNumberVerification ___test;
  ___test.run_test(-1);
}
// END CUT HERE
