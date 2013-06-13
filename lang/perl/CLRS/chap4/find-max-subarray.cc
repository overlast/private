#include <iostream>
#include <vector>
#include <cmath>

namespace std {

int nega_inf = -2147483648;
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

}

int main(void) {
  std::vector<int> input_vec;
  input_vec.push_back(13);
  input_vec.push_back(-3);
  input_vec.push_back(-25);
  input_vec.push_back(20);
  input_vec.push_back(-3);
  input_vec.push_back(-16);
  input_vec.push_back(-23);
  input_vec.push_back(18);
  input_vec.push_back(20);
  input_vec.push_back(-7);
  input_vec.push_back(12);
  input_vec.push_back(-5);
  input_vec.push_back(-22);
  input_vec.push_back(15);
  input_vec.push_back(-4);
  input_vec.push_back(7);

  int low = 0;
  int high = input_vec.size();
  std::vector<int> result_vec = find_max_subarray(input_vec, low, high);
  std::cout << result_vec[0] << ":" << result_vec[1] << ":" << result_vec[2] << std::endl;

  return 1;
}
