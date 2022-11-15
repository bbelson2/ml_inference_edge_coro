#pragma once
#ifndef __CALC_CORE_H__
#define __CALC_CORE_H__

#if defined(_MSC_VER)
#define CORO_STD std::experimental
#elif defined(__clang__)
#define CORO_STD std::experimental
#else
#define CORO_STD std
#endif

#include <resumable.h>

template <typename PARAMS_T, typename ITEM_T, typename OM>
void calculate_image(const PARAMS_T &cp, const std::vector<ITEM_T> &image, std::vector<ITEM_T> &out, const OM &om)
{
  size_t next_index = get_first_index(cp, image);
  for (size_t i = 0; i < cp.height; i++)
  {
    const ITEM_T *item_ptr = get_row_ptr_in_image(cp, image, next_index);
    ITEM_T *output_ptr = om.get_output_ptr(cp, &out[0], i);
    om.process_item(cp, image, item_ptr, next_index, output_ptr);
  }
}

const char *volatile tmp_to_fetch = 0;
char *volatile tmp_to_fetch_w = 0;

template <typename PARAMS_T, typename ITEM_T, typename PREFETCHER_T, class OM>
resumable calculate_image_coro(const PARAMS_T &cp, const std::vector<ITEM_T> &image, std::vector<ITEM_T> &out, const PREFETCHER_T &prefetcher, const OM &om)
{
  co_await CORO_STD::suspend_always{};
  size_t next_index = get_first_index(cp, image);
  for (size_t i = 0; i < cp.height; i++)
  {
    ITEM_T *output_ptr = om.get_output_ptr(cp, &out[0], i);
    const ITEM_T *item_ptr = get_row_ptr_in_image(cp, image, next_index);
    tmp_to_fetch_w = prefetcher.prefetchw((char *)output_ptr, cp.lines_for_output);
    tmp_to_fetch = prefetcher.prefetch((const char *)item_ptr, cp.lines);
    co_await CORO_STD::suspend_always{};
    om.process_item(cp, image, item_ptr, next_index, output_ptr);
  }
}

#endif // __CALC_CORE_H__
