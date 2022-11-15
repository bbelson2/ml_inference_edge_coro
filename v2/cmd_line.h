///////////////////////////////////////////////////////////////////
// Start of common input block

#include <stdexcept>
#include <tclap/CmdLine.h>

// template<typename PARAMS_T>
// concept has_clustering = requires(PARAMS_T p) 
// {
//   { p.clustering } -> std::convertible_to<std::size_t>;
// };

template<typename PARAMS_T>
bool read_input(int ac, char **av, PARAMS_T & cp)
{
  // used: abcdefghlmnopqrstuvwxyz
  try
  {
    // Define and parse command line
    TCLAP::CmdLine cmd(cp.description, ' ', cp.version);
    TCLAP::ValueArg<size_t> arg_batch("b", "batch", "Batch size", true, 0, "unsigned integer", cmd);
    TCLAP::ValueArg<size_t> arg_height("n", "height", "Height of each image", true, 0, "unsigned integer", cmd);
    TCLAP::ValueArg<size_t> arg_width("s", "width", "Width of each image", true, 0, "unsigned integer", cmd);
    TCLAP::ValueArg<size_t> arg_output_dims("p", "output-dims", "Output dimensions per image", false, 1, "unsigned integer", cmd);
    // TCLAP::ValueArg<size_t> arg_output_model("q", "output-model", "Output model", false, 0, "unsigned integer", cmd);

    TCLAP::ValueArg<size_t> arg_repeat("r", "repeats", "Repeats", false, 10, "unsigned integer", cmd);
    TCLAP::ValueArg<size_t> arg_epoch("e", "epochs", "Epochs", true, 0, "unsigned integer", cmd);
    TCLAP::ValueArg<size_t> arg_coroutines("c", "coroutines", "Number of coroutines", true, 0, "unsigned integer", cmd);
    TCLAP::ValueArg<size_t> arg_clustering("l", "clustering", "Size of each cluster", false, 0, "unsigned integer", cmd);
    //TCLAP::ValueArg<size_t> arg_lines("l", "lines", "Number of cache lines to prefetch", false, 4, "unsigned integer", cmd);
    // TCLAP::ValueArg<size_t> arg_managed("a", "managed", "Number of managed parallel tasks", false, 4, "unsigned integer", cmd);

    TCLAP::SwitchArg arg_verbose("v", "verbose", "Verbose output to stdout", cmd);
    TCLAP::SwitchArg arg_flood("f", "flood", "Flood cache before each phase", cmd);
    TCLAP::SwitchArg arg_omit_header("z", "omit-header", "Omit header row in report", cmd);
    TCLAP::ValueArg<std::string> arg_external_metadata("m", "metadata", "Sends metadata to file", false, "", "file name", cmd);
    TCLAP::ValueArg<std::string> arg_output("o", "output", "Sends data to file (- for no output)", false, "", "file name", cmd);
    TCLAP::ValueArg<std::string> arg_summaries("u", "summaries", "Fields to summarise to stdout", false, "", "comma-separated field list", cmd);
    TCLAP::SwitchArg arg_no_telemetry("t", "no-telemetry", "Turns off telemetry", cmd);
    TCLAP::SwitchArg arg_horizontal_telemetry("w", "horizontal", "Telemetry summaries are horizontal", cmd);
    TCLAP::SwitchArg arg_horizontal_telemetry_header("x", "horizontal-header", "Print header for horizontal telemetry summaries", cmd);
    TCLAP::SwitchArg arg_group_by_metric("g", "group-by-metric", "Group performance metrics by metric type (as opposed to test name", cmd);
    TCLAP::ValueArg<int> arg_execution_model("y", "model", "Execution model number (0-6, or -1 for all)", false, -1, "integer", cmd);
    TCLAP::SwitchArg arg_fast("d", "fast", "Skip all models except control and coroutine", cmd);
    cmd.parse(ac, av);

    // convert to conv_params_1d_simple
    cp.batch = arg_batch.getValue();
    cp.height = arg_height.getValue();
    cp.width = arg_width.getValue();
    cp.output_dims = arg_output_dims.getValue();

    cp.repeats = arg_repeat.getValue();
    cp.epochs = arg_epoch.getValue();
    cp.task_count = arg_coroutines.getValue();
    cp.verbose = arg_verbose.getValue();
    cp.flood = arg_flood.getValue();
    cp.omit_header = arg_omit_header.getValue();
    cp.metadata = arg_external_metadata.getValue();
    cp.output = arg_output.getValue();
    cp.summaries = arg_summaries.getValue();
    cp.telemetry = !arg_no_telemetry.getValue();
    cp.horizontal_telemetry = arg_horizontal_telemetry.getValue();
    cp.horizontal_telemetry_header = arg_horizontal_telemetry_header.getValue();
    cp.group_by_metric = arg_group_by_metric.getValue();
    cp.execution_model_index = arg_execution_model.getValue();
    cp.fast = arg_fast.getValue();

    // Validate
    if (cp.output_dims < 1 || cp.output_dims > 2)
    {
      throw std::runtime_error("output_dims must be 1 or 2");
    }

    if (cp.execution_model_index < -1 || cp.execution_model_index >= EMI_COUNT)
    {
      throw std::runtime_error("model must be < EMI_COUNT");
    }

    if (cp.batch < cp.task_count)
    {
      throw std::runtime_error("batch size must be >= task count");
    }

    // Optional parameters (i.e. not supported by all parameters types)

    constexpr bool has_clustering = requires(const PARAMS_T& p) {
      p.clustering;
    };

    if constexpr (has_clustering)
    {
      cp.clustering = arg_clustering.getValue();
      if (cp.clustering > cp.height) 
      {
        throw std::runtime_error("clustering must be <= height");
      }
    }

    cp.complete();

    return true;
  }
  catch (TCLAP::ArgException &e)
  {
    std::cerr << "error: " << e.error() << " for arg " << e.argId() << std::endl;
    return false;
  }
  catch (const std::exception &ex)
  {
    std::cerr << "error: " << ex.what() << std::endl;
    return false;
  }
}

// End of common input block
///////////////////////////////////////////////////////////////////
