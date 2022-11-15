#pragma once

#ifndef __EXECUTION_MODELS_IMPL_H__
#define __EXECUTION_MODELS_IMPL_H__

///////////////////////////////////////////////////////////////////
// Start of managed test infrastructure

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
class managed_prefetch
{
public:
  managed_prefetch(const PARAMS_T &cp, const PREFETCHER_T &prefetcher, const OM &om)
      : cp_(cp), pf_(prefetcher), om_(om)
  {
  }

  void start(const std::vector<ITEM_T> &image, std::vector<ITEM_T> &out)
  {
    image_ = &image;
    out0_ = &out[0];
    i_ = 0;
    next_index_ = get_first_index();
  }
  void step_part_1()
  {
    output_ptr_ = om_.get_output_ptr(cp_, out0_, i_);
    item_ptr_ = get_row_ptr_in_image(cp_, *image_, next_index_);
    external_ptr_w = pf_.prefetchw((char *)output_ptr_, cp_.lines_for_output);
    external_ptr = pf_.prefetch((const char *)item_ptr_, cp_.lines);
  }
  void step_part_2()
  {
    om_.process_item(cp_, *image_, item_ptr_, next_index_, output_ptr_);
    i_++;
  }

protected:
  inline size_t get_first_index() const
  {
    return 0;
  }

private:
  // Parameters
  const PARAMS_T &cp_;
  const PREFETCHER_T &pf_;
  const OM &om_;
  const std::vector<ITEM_T> *image_;
  ITEM_T *out0_;

  // Cached calculations

  // Local variables
  size_t i_, next_index_;
  const ITEM_T *item_ptr_;
  ITEM_T *output_ptr_;

  // Compiler device
  static const char *external_ptr;
  static char *external_ptr_w;
};

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
const char *managed_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T>::external_ptr = nullptr;

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
char *managed_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T>::external_ptr_w = nullptr;

// End of managed test infrastructure
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Start of Protothreads infrastructure

#include "Protothread.h"

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
class pt_prefetch : public Protothread
{
public:
  pt_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T>(const PARAMS_T &cp, const PREFETCHER_T &prefetcher, const OM &om)
      // Initialise everything in order to avoid GCC's:
      // warning: ‘*((void*)&<anonymous> +48)’ may be used uninitialized in this function [-Wmaybe-uninitialized]
      : cp_(cp), om_(om), image_(0), out_(0), pf_(prefetcher), i_(0), next_index_(0), item_ptr_(0), output_ptr_(0), done_(false)
  {
  }
  void start(const std::vector<ITEM_T> &image, std::vector<ITEM_T> &out)
  {
    image_ = &image;
    out_ = &out[0];
    done_ = false;
    Restart();
  }
  virtual bool Run();
  bool is_complete() const { return done_; }
  virtual ~pt_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T>() {}

protected:
  inline size_t get_first_index() const
  {
    return 0;
  }

private:
  // Parameters
  const PARAMS_T &cp_;
  const OM &om_;
  const std::vector<ITEM_T> *image_;
  ITEM_T *out_;
  const PREFETCHER_T &pf_;

  // Cached calculations

  // Local variables
  size_t i_, next_index_;
  const ITEM_T *item_ptr_;
  ITEM_T *output_ptr_;
  bool done_;

  // Compiler device
  static const char *external_ptr;
  static char *external_ptr_w;
};

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
const char *pt_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T>::external_ptr = nullptr;

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
char *pt_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T>::external_ptr_w = nullptr;

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
bool pt_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T>::Run()
{
  // Naive version:
  //
  // template<class OM>
  // void calculate_image(const norm_params& cp, const image_t& image, vec_t& out, const OM& om) {
  //   size_t next_index = get_first_index(cp, image);
  //   for (size_t i = 0; i < cp.height; i++) {
  //     const unit_t* item_ptr = get_row_ptr_in_image(cp, image, next_index);
  //     unit_t* output_ptr = om.get_output_ptr(cp, &out[0], i);
  //     om.process_item(cp, image, item_ptr, next_index, output_ptr);
  //   }
  // }

  PT_BEGIN();
  next_index_ = get_first_index();
  for (i_ = 0; i_ < cp_.height; i_++)
  {
    output_ptr_ = om_.get_output_ptr(cp_, out_, i_);
    external_ptr_w = pf_.prefetchw((char *)output_ptr_, cp_.lines_for_output);
    item_ptr_ = get_row_ptr_in_image(cp_, *image_, next_index_);
    external_ptr = pf_.prefetch((const char *)item_ptr_, cp_.lines);
    PT_YIELD();
    om_.process_item(cp_, *image_, item_ptr_, next_index_, output_ptr_);
  }
  done_ = true;
  PT_END();
}

// End of Protothreads infrastructure
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Start of common execution models

template <typename PARAMS_T, typename ITEM_T, typename OM>
void run_control(const PARAMS_T &cp, const std::vector<std::vector<ITEM_T> > &in_batch, std::vector<std::vector<ITEM_T> > &out_batch, const OM& om)
{
  for (size_t e = 0; e < cp.epochs; e++)
  {
    clear_output(cp, out_batch);
    for (size_t b = 0; b < cp.batch; b++)
    {
      calculate_image(cp, in_batch[b], out_batch[b], om);
    }
  }
}

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
void run_managed_prefetch(const PARAMS_T &cp, const std::vector<std::vector<ITEM_T> > &in_batch, std::vector<std::vector<ITEM_T> > &out_batch, const OM& om, const PREFETCHER_T& pf)
{
  typedef managed_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T> managed_prefetch_t;

  size_t runner_max = cp.task_count;
  std::vector<managed_prefetch_t> image_runners;
  for (size_t r = 0; r < runner_max; r++)
  {
    image_runners.push_back(managed_prefetch_t(cp, pf, om));
  }

  for (size_t e = 0; e < cp.epochs; e++)
  {
    clear_output(cp, out_batch);
    for (size_t b = 0; b < cp.batch; b += runner_max)
    {
      size_t runner_count = runner_max < (cp.batch - b) ? runner_max : (cp.batch - b);
      size_t bl = b;
      for (size_t r = 0; r < runner_count; r++, bl++)
      {
        image_runners[r].start(in_batch[bl], out_batch[bl]);
      }
      for (size_t i = 0; i < cp.height; i++)
      {
        for (size_t r = 0; r < runner_count; r++, bl++)
        {
          image_runners[r].step_part_1();
        }
        for (size_t r = 0; r < runner_count; r++, bl++)
        {
          image_runners[r].step_part_2();
        }
      }
    }
  }  
}

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
void run_proto(const PARAMS_T &cp, const std::vector<std::vector<ITEM_T> > &in_batch, std::vector<std::vector<ITEM_T> > &out_batch, const OM& om, const PREFETCHER_T& pf)
{
  typedef pt_prefetch<PARAMS_T, ITEM_T, OM, PREFETCHER_T> pt_prefetch_t;

  enum
  {
    STATE_EMPTY,
    STATE_READY,
    STATE_DONE
  };

  size_t runner_max = cp.task_count;
  std::vector<pt_prefetch_t> tasks;
  for (size_t r = 0; r < runner_max; r++)
  {
    tasks.push_back(pt_prefetch_t(cp, pf, om));
  }

  for (size_t e = 0; e < cp.epochs; e++)
  {
    clear_output(cp, out_batch);
    std::vector<int> task_states(runner_max, STATE_EMPTY);
    size_t incomplete = cp.batch;
    size_t next = 0;
    while (incomplete > 0)
    {
      for (size_t c = 0; c < tasks.size(); c++)
      {
        pt_prefetch_t &t = tasks[c];
        int &state = task_states[c];
        switch (state)
        {
        case STATE_EMPTY:
          if (next < cp.batch)
          {
            t.start(in_batch[next], out_batch[next]);
            next++;
            state = STATE_READY;
          }
          else
          {
            state = STATE_DONE;
          }
          break;
        case STATE_READY:
          if (t.is_complete())
          {
            if (next < cp.batch)
            {
              t.start(in_batch[next], out_batch[next]);
              next++;
              state = STATE_READY;
            }
            else
            {
              state = STATE_DONE;
            }
            incomplete--;
          }
          else
          {
            t.Run();
          }
          break;
        case STATE_DONE:
          continue;
        }
      }
    }
  }
}

template <typename PARAMS_T, typename ITEM_T, typename OM, typename PREFETCHER_T>
void run_coros(const PARAMS_T &cp, const std::vector<std::vector<ITEM_T> > &in_batch, std::vector<std::vector<ITEM_T> > &out_batch, const OM& om, const PREFETCHER_T& pf)
{
  for (size_t e = 0; e < cp.epochs; e++)
  {
    clear_output(cp, out_batch);

    std::vector<resumable> tasks;
    std::vector<bool> done(cp.task_count, false);
    size_t incomplete = cp.batch;
    for (size_t b = 0; b < cp.task_count; b++)
    {
      tasks.push_back(calculate_image_coro(cp, in_batch[b], out_batch[b], pf, om));
    }

    size_t next = cp.task_count;
    while (incomplete > 0)
    {
      for (size_t c = 0; c < tasks.size(); c++)
      {
        if (done[c])
          continue;
        resumable &t = tasks[c];
        if (t.is_complete())
        {
          if (next < cp.batch)
          {
            tasks[c] = calculate_image_coro(cp, in_batch[next], out_batch[next], pf, om);
            next++;
          }
          else
          {
            done[c] = true;
          }
          incomplete--;
        }
        else
        {
          t.resume();
        }
      }
    }
  }
}

// End of common execution models
///////////////////////////////////////////////////////////////////

#endif // __EXECUTION_MODELS_IMPL_H__

