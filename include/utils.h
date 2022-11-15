#ifndef __UTILS_H__
#define __UTILS_H__

#include <vector>
#include <string>
#include <string.h>

inline std::vector<std::string> split(const std::string& list, char sep) {
  std::vector<std::string> res;
  if (list.size() == 0) {
    return res;
  }
  const char* next = list.c_str();
  while (next) {
    const char* end = strchr(next, sep);
    if (!end) {
      res.push_back(std::string(next));
      break;
    }
    res.push_back(std::string(next, end - next));
    next = end + 1;
  }
  return res;
}

inline std::vector<int> split_numbers(const std::string& list, char sep) {
  std::vector<std::string> parts = split(list, sep);
  std::vector<int> res;
  for (size_t i = 0; i < parts.size(); i++) {
    res.push_back(std::stoi(parts[i]));
  }
  return res;
}

inline std::string join(const std::vector<std::string>& list, const std::string& sep) {
  std::string res = "";
  for (size_t i = 0; i < list.size(); i++) {
    if (i > 0) {
      res += sep;
    }
    res += list[i];
  }
  return res;
}

inline std::string join(const std::vector<std::string>& list, char sep) {
  return join(list, std::string(1, sep));
}

template<class IT>
inline std::string join(IT b, IT e, const std::string& sep) {
  std::vector<std::string> strs;
  for (auto i = b; i != e; i++) {
    strs.push_back(std::to_string(*i));
  }
  return join(strs, sep);
}

template<class IT>
inline std::string join(IT b, IT e, char sep) {
  return join(b, e, std::string(1, sep));
}

template<class T>
inline std::string join(const std::vector<T>& list, const std::string& sep) {
  std::vector<std::string> strs;
  for (auto i : list) {
    strs.push_back(std::to_string(i));
  }
  return join(strs, sep);
}

template<class T>
inline std::string join(const std::vector<T>& list, char sep) {
  return join(list, std::string(1, sep));
}

template<class T>
inline std::string table_join(const std::vector<T>& list, size_t width, char field_sep, char row_sep) {
  std::vector<std::string> rows;
  for (auto it = list.begin(); it != list.end(); it += width) {
    rows.push_back(join(it, it + width, field_sep));
  }
  return join(rows, std::string(1, row_sep));
}

#endif
