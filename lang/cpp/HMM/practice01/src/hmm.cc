#include <vector>
#include <iostream>
#include "hmm.h"


using namespace std;

int main(int args, char** argv) {
  int res = 0;
  string sample = "Toshinori Satou";
  
  vector<pair<vector<int>, vector<int> > > lattice;
  vector<pair<int, int> > node;

  int node_size = 0;
  int sample_len = sample.size();
  cout << sample_len << endl;
  for (int i = 0; i < sample_len; i++) {
    vector <int> begin;
    vector <int> end;
    lattice.push_back(pair<vector<int>, vector<int> >(begin, end));
  }

  for (int i = 0; i < sample_len; i++) {
    for (int j = i; j < sample_len; j++) {
      int surface_len = sample_len - j;
      cout << i << ":" << j << ":" << surface_len << endl;
      node.push_back(pair<int, int>(i, surface_len));
      node_size++;
      (lattice[i].first).push_back(node_size - 1);
      (lattice[i + surface_len - 1].second).push_back(node_size - 1);
    }
  }

  for ( vector<pair<vector<int>, vector<int> > >::iterator bi = lattice.begin(), ei = lattice.end(); bi != ei; ++bi) {
    for (vector<int>::iterator bit = ((*bi).first).begin(), eit = ((*bi).first).end(); bit != eit; ++bit) {
      cout << sample.substr((node[*bit]).first, (node[*bit]).second) << endl;
    }
    cout << "--" << endl;
  }

  cout << "----" << endl;
  
  for ( vector<pair<vector<int>, vector<int> > >::iterator bi = lattice.end(), ei = lattice.begin(); bi != ei;) {
    --bi;
    for (vector<int>::iterator bit = ((*bi).second).begin(), eit = ((*bi).second).end(); bit != eit; ++bit) {
      cout << sample.substr((node[*bit]).first, (node[*bit]).second) << endl;
    }
    cout << "--" << endl;
  }

  return res;
}
