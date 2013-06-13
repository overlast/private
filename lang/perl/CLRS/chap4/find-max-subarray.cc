#include <iostream>
#include <vector>
#include <cmath>
#include "picojson.h"
#include <fstream>
#include <string>
#include <sstream>

int nega_inf = -2147483648;

using namespace std;
vector<int> find_max_crossing_subarray(vector<int> vec, int low, int mid, int high) {
  vector<int> result_vec;
  int left_sum = nega_inf;
  int right_sum = nega_inf;
  int sum = 0;
  int max_left = -1;
  int max_right = -1;
  for (int i = mid; i >= low; i--) {
    sum = sum + vec[i];
    if (sum > left_sum) {
      left_sum = sum;
      max_left = i;
    }
  }
  sum = 0;
  for (int i = mid + 1; i <= high; i++) {
    sum = sum + vec[i];
    if (sum > right_sum) {
      right_sum = sum;
      max_right = i;
    }
  }
  result_vec.push_back(max_left);
  result_vec.push_back(max_right);
  result_vec.push_back(left_sum + right_sum);
  return result_vec;
}

vector<int> find_max_subarray (vector<int> vec, int low, int high){
  vector<int> result_vec;
  if (low == high) {
    result_vec.push_back(low);
    result_vec.push_back(high);
    result_vec.push_back(vec[low]);
    return result_vec;
  } else {
    int mid = (low + high) / 2;
    vector<int> left_vec = find_max_subarray(vec, low, mid);
    vector<int> right_vec = find_max_subarray(vec, mid + 1, high);
    vector<int> cross_vec = find_max_crossing_subarray(vec, low, mid, high);
    if ((left_vec[2] >= right_vec[2]) && (left_vec[2] >= cross_vec[2])) {
      return left_vec;
    } else if ((right_vec[2] >=left_vec[2]) && (right_vec[2] >= cross_vec[2])) {
      return right_vec;
    } else {
      return cross_vec;
    }
  }
}

vector<int> get_input_vec_from_json(string filepath) {
  vector<int> input_vec;
  picojson::value v;
  stringstream ss;
  ifstream ifs;
  ifs.open(filepath.c_str(), std::ios::binary);
  ss << ifs.rdbuf();
  ifs.close();
  ss >> v;
  picojson::array& arr = v.get<picojson::object>()["num"].get<picojson::array>();
  int i, l = arr.size();
  for (i = 0; i < l; i++) {
    const int num = (int)(arr[i].get<double>());
    input_vec.push_back(num);
  }
  return input_vec;
}

int main(int argc, char *argv[]) {
  string filepath = argv[1];
  vector<int> input_vec = get_input_vec_from_json(filepath);
  int low = 0;
  int high = input_vec.size() - 1;
  vector<int> result_vec = find_max_subarray(input_vec, low, high);
  cout << result_vec[0] << ":" << result_vec[1] << ":" << result_vec[2] << endl;
  return 1;
}
