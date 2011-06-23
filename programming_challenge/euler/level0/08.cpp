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
  int solve(string str) {
    int result = 0;
    int i = 0;
    int num = 0;
    stringstream ss;
    static const string empty_string;
    for (i = 0; i < (str.size() - 4); i++) {
      int tmp = 1;
      ss << str[i]; ss >> num; ss.str(empty_string);ss.clear(); tmp *= num;
      ss << str[i+1]; ss >> num; ss.str(empty_string);ss.clear(); tmp *= num;
      ss << str[i+2]; ss >> num; ss.str(empty_string);ss.clear(); tmp *= num;
      ss << str[i+3]; ss >> num; ss.str(empty_string);ss.clear(); tmp *= num;
      ss << str[i+4]; ss >> num; ss.str(empty_string);ss.clear(); tmp *= num;
      if (result < tmp) { result = tmp; }
    }
    return result;
  }
};

// BEGIN CUT HERE
int main(int argc, char *argv[]) {
  int result = 0;
  Solution obj;

  string str = "7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450";

  result = obj.solve(str);
  cout << result << endl;
  return 0;
}
// END CUT HERE

