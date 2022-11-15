#pragma once
#ifndef __REPORT_H__
#define __REPORT_H__

#include "pe_monitor.h"
#include "pe_monitor_coll.h"
#include <iostream>
#include <fstream>
#include <algorithm>

template <typename PARAMS_T>
std::ostream *get_output_stream(const PARAMS_T &params, std::ofstream &of_output)
{
  // Prepare output stream
  std::ostream *pof = &std::cout;
  if (params.output == "-")
  {
    pof = nullptr;
  }
  else if (params.output.size())
  {
    of_output = std::ofstream(params.output);
    pof = &of_output;
  }
  return pof;
}

template <typename PARAMS_T>
void report_line_header(const PARAMS_T &params, std::ostream *pof, const pem_test &pm)
{
  if (pof) {
    *pof << join(params.report_detail_headers, params.sep); 
    std::vector<std::string> pem_headers;
    std::transform(pm.descriptors.begin(), pm.descriptors.end(), 
      std::back_inserter(pem_headers), [](const pem_desc& desc){
        return desc.name;
      });
    *pof << params.sep << join(pem_headers, params.sep); 
    *pof << std::endl;
  }
}

template <typename PARAMS_T>
void report_line_values(const PARAMS_T &params, 
  size_t control_model, std::ostream *pof, size_t coroutines, bool pf, int64_t duration_us,
  size_t pe_count, const long long pe_data[])
{
  if (pof) {
    params.report_detail_values(control_model, *pof, coroutines, pf, duration_us);
    for (size_t i = 0; i < pe_count; i++) {
      *pof << params.sep << pe_data[i];
    }
    *pof << std::endl;
  }
}

#endif // __REPORT_H__
