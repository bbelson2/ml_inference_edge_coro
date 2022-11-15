#include "utils.h"
#include <fixed_point.h>
#include "prefetch1.h"

#include "execution_models.h"
#include "calc_core.h"
#include "execution_models_impl.h"
#include "report.h"
#include "data.h"
#include "context.h"
#include "cmd_line.h"

///////////////////////////////////////////////////////////////////
// Main program

class rndleaf_params
{
public:
  typedef fix_t unit_t;

  typedef std::vector<unit_t> image_t;
  typedef std::vector<image_t> image_vec_t;

  typedef std::vector<unit_t> vec_t;
  typedef std::vector<vec_t> tensor_t;
public:
  rndleaf_params()
      : repeats(1), epochs(1), batch(1), height(128), width(128), clustering(0), 
        output_dims(1), task_count(1), 
        flood(true), verbose(false), omit_header(false),
        metadata(""), output("-"), summaries(default_summaries),
        telemetry(true), horizontal_telemetry(false), horizontal_telemetry_header(false), group_by_metric(false),
        execution_model_index(-1), fast(false),
        lines(1), lines_for_output(1),
        execution_models{true, false, false, false, false, true, true},
        output_model_name("rndleaf"),
        report_detail_headers{"model", "test_num", "test_name", "tasks", "epochs", "batch", "height", "width", "clustering", "dims", "total", "unit", "pf", "unitsize", "lines"},
        report_summary_headers{"repeats", "epochs", "batch", "output_dims", "output_model", "tasks", "height", "width", "clustering", "unitsize", "lines"},
        sep(",")
  {
  }
  // Implementation methods
  std::ostream& report_detail_values(size_t execution_model, std::ostream& o, 
    size_t coroutines, bool pf, intmax_t duration_us) const 
  {
    auto unit = (double)duration_us / ((double)epochs * batch * height * width);
    o << output_model_name << sep << execution_model << sep << summary_names[execution_model] << sep << coroutines << sep << epochs << sep << batch << sep << height << sep << width << sep << clustering << sep << output_dims << sep
      << duration_us << sep << unit << sep << pf << sep << sizeof(unit_t) << sep << lines;      
    return o;  
  }
  std::ostream& report_summary_values(std::ostream& o) const
  {
    int output_model = 0;
    o << repeats << sep << epochs << sep << batch << sep << output_dims << sep << output_model << sep
      << task_count << sep << height << sep << width << sep << clustering << sep << sizeof(unit_t) << sep << lines;
    return o; 
  }
  void complete() 
  {
    output_dims = 1; // output dims always = 1
    lines = calc_lines_for_row<unit_t>(width);
    lines_for_output = (output_dims == 1) ? 1 : lines;
    ::calculate_included_summaries(fast, execution_model_index, execution_models);
  }
public:
  // Test parameters
  size_t repeats; // Number of times each test is repeated
  size_t epochs;  // Number of times batch is examined
  size_t batch;       // Number of samples in batch
  size_t height;      // Number of rows in an image
  size_t width;       // Number of pixels in a row
  size_t clustering;  // Number of rows that are clustered in sequence
  size_t output_dims; // Dimensions of output for each image (1 or 2)
  // int output_model;   // Use the fixed random number generator
  size_t task_count;  // Number of coroutines (or equivalent)
  bool flood;                       // Run huge memory operation before each phase

  // Report controls
  bool verbose;                     // Verbose reporting
  bool omit_header;                 // Omit header row from report
  std::string metadata;             // Writes metadata to file
  std::string output;               // Writes data to file
  std::string summaries;            // Fields to summarise to std::out
  bool telemetry;                   // Run telemetry through H/W registers
  bool horizontal_telemetry;        // telemetry summaries in a single line, with parameters
  bool horizontal_telemetry_header; // header for single-line telemetry summaries
  bool group_by_metric;             // Group telemetry data by metric (as opposed to by test name)
  int execution_model_index;          // Which model to run (-1 for all)
  bool fast;                        // Skip all models except control and coroutine

  // Intermediate variables (calculated at start)
  size_t lines;            // Number of lines to prefetch
  size_t lines_for_output; // Number of lines to prefetch for output
  bool execution_models[EMI_COUNT];   // Whether to run each control model

  // Constants
  std::string output_model_name;
  std::vector<std::string> report_detail_headers, report_summary_headers;
  std::string sep;

public:
  inline static const char* default_summaries = "cpu_cycles,instructions,d_cache_reads,d_cache_misses";
  inline static const char* description = "Test bed for implementation of Btree+ leaf visit algorithm, investigating the impact of cache prefetch using coroutines, and controlling the degree of randomness in the ordering of the leaves";
  inline static const char* version = "1.0";
};

#define PEM_SETUP_WHICH 0

template<typename PARAMS_T>
class output_model_rndleaf
{
public:
  typedef typename PARAMS_T::unit_t unit_t; 
  typedef typename PARAMS_T::vec_t vec_t; 
  typedef typename PARAMS_T::image_t image_t; 
public:
  output_model_rndleaf() {}

  inline size_t get_output_pixel_count(const PARAMS_T &cp) const
  {
    return cp.height;
  }
  inline typename PARAMS_T::unit_t *get_output_ptr(const PARAMS_T &cp, unit_t *output_base, size_t row_index) const
  {
    return output_base + row_index;
  }
  inline void process_item(const PARAMS_T &cp, const image_t &image, const unit_t *item_ptr,
                           size_t &next_index, unit_t *output_ptr) const
  {
    unit_t sum = 0;
    for (size_t j = 0; j < cp.width - 1; j++, item_ptr++)
    {
      sum += *item_ptr;
    }
    // The last item in the leaf is the index of the next leaf
    next_index = *item_ptr;
    *output_ptr = sum;
  }
};

int main(int ac, char **av)
{
  // Read parameters from command-line
  rndleaf_params params;
  ::read_input(ac, av, params);

  // Initialise execution context
  context_t<rndleaf_params> context(params);
  context.init_output_stream();
  context.init_telemetry(PEM_SETUP_WHICH);
  context.report_line_header();

  // Simulated data
  rndleaf_params::image_vec_t in_batch;
  rndleaf_params::tensor_t out_batch, control_out_batch;
  create_data_int_clustered(params, in_batch, out_batch);

  // Avoid 1st-time effects
  output_model_rndleaf<rndleaf_params> om;
  context.before_test();
  run_control(params, in_batch, out_batch, om);
  control_out_batch = out_batch;

  // Run tests
  for (size_t repeat = 0; repeat < params.repeats; repeat++)
  {
    if (context.params.execution_models[EMI_CONTROL]) {  
      context.before_test();
      context.perf_record(EMI_CONTROL, [&params, &in_batch, &out_batch, &om]()
        {
          run_control(params, in_batch, out_batch, om);
        });
      context.report_line_values(EMI_CONTROL, 1, true);
    }
    if (context.params.execution_models[EMI_MANAGED_NOPREFETCH]) {
      context.before_test();
      context.perf_record(EMI_MANAGED_NOPREFETCH, [&params, &in_batch, &out_batch, &om]()
        {
          prefetch_false pf;
          run_managed_prefetch(params, in_batch, out_batch, om, pf);
        });
      context.report_line_values(EMI_MANAGED_NOPREFETCH, params.task_count, false);
      if (!::check_results(out_batch, control_out_batch, EMI_MANAGED_NOPREFETCH)) {
        return -1;
      }
    }
    if (context.params.execution_models[EMI_MANAGED_PREFETCH]) {
      context.before_test();
      context.perf_record(EMI_MANAGED_PREFETCH, [&params, &in_batch, &out_batch, &om]()
        {
          prefetch_true pf;
          run_managed_prefetch(params, in_batch, out_batch, om, pf);
        });
      context.report_line_values(EMI_MANAGED_PREFETCH, params.task_count, false);
      if (!::check_results(out_batch, control_out_batch, EMI_MANAGED_PREFETCH)) {
        return -1;
      }
    }
    if (context.params.execution_models[EMI_PROTO_NOPREFETCH]) {
      context.before_test();
      context.perf_record(EMI_PROTO_NOPREFETCH, [&params, &in_batch, &out_batch, &om]()
        {
          prefetch_false pf;
          run_proto(params, in_batch, out_batch, om, pf);
        });
      context.report_line_values(EMI_PROTO_NOPREFETCH, params.task_count, false);
      if (!::check_results(out_batch, control_out_batch, EMI_PROTO_NOPREFETCH)) {
        return -1;
      }
    }
    if (context.params.execution_models[EMI_PROTO_PREFETCH]) {
      context.before_test();
      context.perf_record(EMI_PROTO_PREFETCH, [&params, &in_batch, &out_batch, &om]()
        {
          prefetch_true pf;
          run_proto(params, in_batch, out_batch, om, pf);
        });
      context.report_line_values(EMI_PROTO_PREFETCH, params.task_count, false);
      if (!::check_results(out_batch, control_out_batch, EMI_PROTO_PREFETCH)) {
        return -1;
      }
    }
    if (context.params.execution_models[EMI_CORO_NOPREFETCH]) {
      context.before_test();
      context.perf_record(EMI_CORO_NOPREFETCH, [&params, &in_batch, &out_batch, &om]()
        {
          prefetch_false pf;
          run_coros(params, in_batch, out_batch, om, pf);
        });
      context.report_line_values(EMI_CORO_NOPREFETCH, params.task_count, false);
      if (!::check_results(out_batch, control_out_batch, EMI_CORO_NOPREFETCH)) {
        return -1;
      }
    }
    if (context.params.execution_models[EMI_CORO_PREFETCH]) {
      context.before_test();
      context.perf_record(EMI_CORO_PREFETCH, [&params, &in_batch, &out_batch, &om]()
        {
          prefetch_true pf;
          run_coros(params, in_batch, out_batch, om, pf);
        });
      context.report_line_values(EMI_CORO_PREFETCH, params.task_count, true);
      if (!::check_results(out_batch, control_out_batch, EMI_CORO_PREFETCH)) {
        return -1;
      }
    }
  }

  // Report
  context.report_telemetry_summaries(std::cout);

  return 0;
}
