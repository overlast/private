#include <algorithm>
#include <cstdio>
#include <cstdlib>

class KSP01 {
private:
  int arr_len;
  int max_total_weight;
  int* weight_arr;
  int* value_arr;
  
public:
  KSP01(int* n, int* W, int* w, int* v) {
    int i = 0;
    arr_len = *n;
    max_total_weight = *W;
    weight_arr = (int*)calloc(sizeof(int), arr_len);
    value_arr = (int*)calloc(sizeof(int), arr_len);
    for (i = 0; i < arr_len; i++) {
      weight_arr[i] = w[i];
      value_arr[i] = v[i];
    }
  }

  ~KSP01() {
    free(value_arr);
    free(weight_arr);
  }

  int rec(int i, int j) {
    int res;
    if (i == arr_len) {
      res = 0; // no bags are there.
    }
    else if (j < weight_arr[i]) {
      res = rec(i + 1, j); // weight_arr[i] is larger than max_total_weight;
    }
    else {
      res = std::max(rec(i + 1, j), rec(i + 1, j - weight_arr[i]) + value_arr[i]);
    }
    
    return res;
  }
  
  void solve() {
    printf("%d\n", rec(0, max_total_weight));
    return;
  }
};

int main(void) {
  KSP01* ksp;
  int n = 4;
  int W = 5;
  int* w = (int*)calloc(sizeof(int), n);
  int* v = (int*)calloc(sizeof(int), n);

  w[0] = 2;
  w[1] = 1;
  w[2] = 3;
  w[3] = 2;
  v[0] = 3;
  v[1] = 2;
  v[2] = 4;
  v[3] = 2;

  ksp = new KSP01(&n, &W, w, v);
  ksp->solve();

  free(v);
  free(w);
}

