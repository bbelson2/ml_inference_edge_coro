#ifndef __PREFETCH1_H__
#define __PREFETCH1_H__

#include <stddef.h>

///////////////////////////////////////////////////////////////////
// Prefetch

// https://stackoverflow.com/a/28166605
#if defined(__clang__)
#define PREFETCH(p) __builtin_prefetch(p)
#define PREFETCHW(p) __builtin_prefetch(p, 1)
#elif defined(__GNUC__) || defined(__GNUG__)
#define PREFETCH(p) __builtin_prefetch(p)
#define PREFETCHW(p) __builtin_prefetch(p, 1)
#elif defined(_MSC_VER)
#include <xmmintrin.h>
#define PREFETCH(p) _mm_prefetch((const char*)p, _MM_HINT_T0)
//#define PREFETCHW(p) _mm_prefetch((const char*)p, _MM_HINT_ET1) // See https://stackoverflow.com/a/46525326
#define PREFETCHW(p) _mm_prefetch((const char*)p, _MM_HINT_ENTA) // See Because _MM_HINT_ET1 is not implemented yet
#endif

// TODO - drive this value from arch
#define LINE_SIZE 64

inline const char* inl_prefetch_n(const char* ptr, size_t n) 
{
  while (n) {
    PREFETCH(ptr);
    ptr += LINE_SIZE;
    n--;
  }
  return ptr;
}

inline char* inl_prefetchw_n(char* ptr, size_t n) 
{
  while (n) {
    PREFETCHW(ptr);
    ptr += LINE_SIZE;
    n--;
  }
  return ptr;
}

class prefetch_true {
public:
  const char* prefetch(const char* ptr, size_t n) const {
    return inl_prefetch_n(ptr, n);
  }
  char* prefetchw(char* ptr, size_t n) const {
    return inl_prefetchw_n(ptr, n);
  }
  bool operator()() const { return true; }
};

inline const char* inl_prefetch_n_npf(const char* ptr, size_t n) 
{
  while (n) {
    //PREFETCH(p);
    ptr += LINE_SIZE;
    n--;
  }
  return ptr;
}

inline char* inl_prefetchw_n_npf(char* ptr, size_t n) 
{
  while (n) {
    //PREFETCHW(p);
    ptr += LINE_SIZE;
    n--;
  }
  return ptr;
}

class prefetch_false {
public:
  const char* prefetch(const char* ptr, size_t n) const {
    return inl_prefetch_n_npf(ptr, n);
  }
  char* prefetchw(char* ptr, size_t n) const {
    return inl_prefetchw_n_npf(ptr, n);
  }
  bool operator()() const { return false; }
};

#endif // #ifndef __PREFETCH1_H__
