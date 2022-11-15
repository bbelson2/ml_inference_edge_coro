#pragma once
#ifndef __DATA_H__
#define __DATA_H__

#include <random>
#include <numeric>

template<typename PARAMS_T, typename ITEM_T>
void clear_output(const PARAMS_T &cp, std::vector<std::vector<ITEM_T> > &out)
{
  for (size_t i = 0; i < cp.batch; i++)
  {
    auto &outi = out[i];
    std::fill(outi.begin(), outi.end(), (ITEM_T)0);
  }
}

#if defined(__FIXED_POINT_H__)

template<typename PARAMS_T, typename ITEM_T>
void create_data_fixed_point(const PARAMS_T &cp, 
  std::vector<std::vector<ITEM_T> > &in_batch, 
  std::vector<std::vector<ITEM_T> > &out_batch, 
  std::vector<ITEM_T> *weights = 0, ITEM_T *bias = 0,
  std::vector<ITEM_T> *kernel = 0, size_t kernel_width = 0
  )
{
  std::mt19937 engine; // Mersenne twister MT19937
  std::uniform_int_distribution<int> distribution(0, 255);
  engine.seed(5489);
  auto rand = [&]()
  { return fix_float_to_int((float)distribution(engine) / 256.0f); };
  auto rand_weights = [&]()
  { return fix_float_to_int((float)distribution(engine) / 256.0f); };
  auto image_pixel_count = cp.width * cp.height;
  auto output_pixel_count = (cp.output_dims == 1) ? cp.height : (cp.height * cp.width);

  // Fill in each input image and the indices
  in_batch.resize(cp.batch);
  out_batch.resize(cp.batch);
  for (size_t i = 0; i < cp.batch; i++)
  {
    auto &ini = in_batch[i];
    ini.resize(image_pixel_count);
    std::generate(ini.begin(), ini.end(), rand);

    // For a CNN, set all edges to 0
    if (kernel && kernel_width) {
      std::fill_n(ini.begin(), cp.width, (ITEM_T)0);
      std::fill_n(ini.end() - cp.width, cp.width, (ITEM_T)0);
      for (size_t j = 1; j < cp.height - 1; j++) {
        ini[(j * cp.width)] = (ITEM_T)0;
        ini[(j * cp.width) + cp.width - 1] = (ITEM_T)0;
      }
    }

    auto &outi = out_batch[i];
    outi.resize(output_pixel_count, (ITEM_T)0);
  }
  if (weights) {
    weights->resize(image_pixel_count);
    std::generate(&(*weights)[0], (&(*weights)[0]) + image_pixel_count, rand_weights);
  }
  if (bias) {
    *bias = rand_weights();
  }
  if (kernel && kernel_width) {
    kernel->resize(kernel_width * kernel_width);
    std::generate(kernel->begin(), kernel->end(), rand_weights);
  }
}

#endif // defined(__FIXED_POINT_H__)

template<typename PARAMS_T, typename ITEM_T>
void create_data_floating_point(const PARAMS_T &cp, 
  std::vector<std::vector<ITEM_T> > &in_batch, 
  std::vector<std::vector<ITEM_T> > &out_batch, 
  std::vector<ITEM_T> *weights = 0, ITEM_T *bias = 0,
  std::vector<ITEM_T> *kernel = 0, size_t kernel_width = 0
  )
{
  std::mt19937 engine; // Mersenne twister MT19937
  std::uniform_int_distribution<int> distribution(0, 255);
  engine.seed(5489);
  auto rand = [&]()
  { return (ITEM_T)distribution(engine) / (ITEM_T)256.0; };
  auto rand_weights = [&]()
  { return (ITEM_T)distribution(engine) / (ITEM_T)256.0; };
  auto image_pixel_count = cp.width * cp.height;
  auto output_pixel_count = (cp.output_dims == 1) ? cp.height : (cp.height * cp.width);

  // Fill in each input image and the indices
  in_batch.resize(cp.batch);
  out_batch.resize(cp.batch);
  for (size_t i = 0; i < cp.batch; i++)
  {
    auto &ini = in_batch[i];
    ini.resize(image_pixel_count);
    std::generate(ini.begin(), ini.end(), rand);

    // For a CNN, set all edges to 0
    if (kernel && kernel_width) {
      std::fill_n(ini.begin(), cp.width, (ITEM_T)0);
      std::fill_n(ini.end() - cp.width, cp.width, (ITEM_T)0);
      for (size_t j = 1; j < cp.height - 1; j++) {
        ini[(j * cp.width)] = (ITEM_T)0;
        ini[(j * cp.width) + cp.width - 1] = (ITEM_T)0;
      }
    }

    auto &outi = out_batch[i];
    outi.resize(output_pixel_count, (ITEM_T)0);
  }
  if (weights) {
    weights->resize(image_pixel_count);
    std::generate(&(*weights)[0], (&(*weights)[0]) + image_pixel_count, rand_weights);
  }
  if (bias) {
    *bias = rand_weights();
  }
  if (kernel && kernel_width) {
    kernel->resize(kernel_width * kernel_width);
    std::generate(kernel->begin(), kernel->end(), rand_weights);
  }
}

template<typename PARAMS_T, typename ITEM_T>
void create_data_int_unclustered(const PARAMS_T &cp, 
  std::vector<std::vector<ITEM_T> > &in_batch, 
  std::vector<std::vector<ITEM_T> > &out_batch,
  bool create_link_indices)
{
  std::mt19937 engine; // Mersenne twister MT19937
  std::uniform_int_distribution<int> distribution(0, 255);
  engine.seed(5489);
  auto rand = [&]()
  { return (ITEM_T)distribution(engine); };
  auto image_pixel_count = cp.width * cp.height;
  auto output_pixel_count = (cp.output_dims == 1) ? cp.height : (cp.height * cp.width);

  // Fill in each input image and the indices
  in_batch.resize(cp.batch);
  out_batch.resize(cp.batch);
  for (size_t i = 0; i < cp.batch; i++)
  {
    auto &ini = in_batch[i];
    ini.resize(image_pixel_count);
    auto *p = &(ini[0]);
    std::generate(p, p + image_pixel_count, rand);

    auto &outi = out_batch[i];
    outi.resize(output_pixel_count, (ITEM_T)0);
  }
  // Set links between leaf records
  if (create_link_indices) {
    std::vector<ITEM_T> indices;
    indices.resize(cp.height);
    std::iota(std::begin(indices), std::end(indices), 0);
    // Shuffle all except the first. 
    std::shuffle(std::begin(indices) + 1, std::end(indices), engine);
    // The vector now contains the indices of the leaves in the order we wish to visit.
    
    // Next, we need to change the last value in each leaf to point to the next leaf.
    // In this scheme, we always start on leaf 0, and next=0 means stop. 
    // Prepare the values which will be used for all images in the batch.
    std::vector<ITEM_T> next(cp.height);
    for (size_t i = 0; i < cp.height; i++) {
      next[indices[i]] = (i < cp.height - 1) ? indices[i+1] : 0;
    }

    // Finally apply these values to the last item in each leaf
    for (size_t i = 0; i < cp.batch; i++) {
      auto &ini = in_batch[i];
      auto *p = &(ini[cp.width - 1]);
      for (size_t j = 0; j < cp.height; j++, p += cp.width) {
        *p = next[j];
      }
    } 
  }
}


// This data arrangement  is similar to that created by 
// create_data_int(..., bool create_link_indices) with create_link_indices set 
// to true, but has the additional wrinkle that the leaf shuffling keeps groups
// of n = clustering leafs together, in an island of order. 
template<typename PARAMS_T, typename ITEM_T>
void create_data_int_clustered(const PARAMS_T &cp, 
  std::vector<std::vector<ITEM_T> > &in_batch, 
  std::vector<std::vector<ITEM_T> > &out_batch)
{
  std::mt19937 engine; // Mersenne twister MT19937
  std::uniform_int_distribution<int> distribution(0, 255);
  engine.seed(5489);
  auto rand = [&]()
  { return (ITEM_T)distribution(engine); };
  auto image_pixel_count = cp.width * cp.height;
  auto output_pixel_count = (cp.output_dims == 1) ? cp.height : (cp.height * cp.width);

  // Fill in each input image and the indices
  in_batch.resize(cp.batch);
  out_batch.resize(cp.batch);
  for (size_t i = 0; i < cp.batch; i++)
  {
    auto &ini = in_batch[i];
    ini.resize(image_pixel_count);
    auto *p = &(ini[0]);
    std::generate(p, p + image_pixel_count, rand);

    auto &outi = out_batch[i];
    outi.resize(output_pixel_count, (ITEM_T)0);
  }

  // Set links between leaf records
  size_t group_size = (cp.clustering == 0) ? 1 : cp.clustering;
  size_t chunks = cp.height / group_size;
  if ((chunks * group_size) < cp.height) {
    chunks++;
  }
  std::vector<ITEM_T> chunk_indices;
  chunk_indices.resize(chunks);
  std::iota(std::begin(chunk_indices), std::end(chunk_indices), 0);
  // Shuffle all except the first. 
  std::shuffle(std::begin(chunk_indices) + 1, std::end(chunk_indices), engine);
  // std::cout << "chunks: " << join(chunk_indices, ',') << std::endl;

  std::vector<ITEM_T> indices;
  indices.resize(cp.height);
  size_t k = 0;
  for (size_t i = 0; i < chunks; i++) {
    size_t new_chunk = chunk_indices[i];
    size_t chunk_size = (new_chunk == (chunks - 1)) ? (cp.height - (new_chunk * group_size)) : group_size;
    size_t offset = (new_chunk * group_size);
    for (size_t j = 0; j < chunk_size; j++, k++) {
      indices[k] = offset + j;
    }
  }
  // std::cout << "indices: " << join(indices, ',') << std::endl;
  // The indices vector now contains the indices of the leaves in the order we wish to visit.
  
  // Next, we need to change the last value in each leaf to point to the next leaf.
  // In this scheme, we always start on leaf 0, and next=0 means stop. 
  // Prepare the values which will be used for all images in the batch.
  std::vector<ITEM_T> next(cp.height);
  for (size_t i = 0; i < cp.height; i++) {
    next[indices[i]] = (i < cp.height - 1) ? indices[i+1] : 0;
  }

  // Finally apply these values to the last item in each leaf
  for (size_t i = 0; i < cp.batch; i++) {
    auto &ini = in_batch[i];
    auto *p = &(ini[cp.width - 1]);
    for (size_t j = 0; j < cp.height; j++, p += cp.width) {
      *p = next[j];
    }
  } 
}

typedef uint16_t clear_cache_t;

// This is placed in global space to prevent the optimiser
// from optimising out the whole of clear_cache()
std::vector<std::vector<clear_cache_t>> cached_buf;

void clear_cache()
{
  std::vector<std::vector<clear_cache_t>> &buf = cached_buf;
  size_t outer = 64000;
  size_t inner = 1000;
  for (size_t i = 0; i < outer; i++)
  {
    std::vector<clear_cache_t> inner_buf(inner);
    for (size_t j = 0; j < inner; j++)
    {
      inner_buf[j] = (clear_cache_t)j;
    }
    buf.push_back(inner_buf);
  }
  buf.clear();
}

template<typename ITEM_T>
inline size_t calc_lines_for_row(size_t width)
{
  size_t cb = (sizeof(ITEM_T) * width);
  size_t lines = cb / LINE_SIZE;
  if ((lines * LINE_SIZE) < cb)
  {
    lines++;
  }
  return lines;
}

template<typename ITEM_T>
inline bool check_results(const std::vector<std::vector<ITEM_T> >& expected, 
    const std::vector<std::vector<ITEM_T> >& actual, size_t which_summary,
    bool verbose = false)
{
  if (actual != expected)
  {
    std::cerr << "inconsistent results for " << summary_names[which_summary] << std::endl;
    for (size_t i = 0; i < expected.size(); i++) {
      if (actual[i] != expected[i]) {
        std::cerr << "Error in vector #" << i << std::endl;
        const std::vector<ITEM_T>& a = actual[i];
        const std::vector<ITEM_T>& e = expected[i];
        for (size_t j = 0; j < a.size(); j++) {
          if (a[j] != e[j]) {
              std::cerr << "Error at #" << j << ": " << a[j] << " != " << e[j] << std::endl;
          }
        }
      }
    }
    return false;
  }
  return true;
}

///////////////////////////////////////////////////////////////////
// Accessors

template<typename PARAMS_T, typename ITEM_T>
inline size_t get_first_index(
    const PARAMS_T &cp,
    const std::vector<ITEM_T> &image)
{
  return 0;
}

template<typename PARAMS_T, typename ITEM_T>
inline const ITEM_T *get_row_ptr_in_image(
    const PARAMS_T &cp,
    const std::vector<ITEM_T> &image,
    size_t row_index)
{
  return &(image[0]) + (cp.width * row_index);
}

template<typename PARAMS_T, typename ITEM_T>
inline ITEM_T *get_row_ptr_in_image(
    const PARAMS_T &cp,
    std::vector<ITEM_T> &image,
    size_t row_index)
{
  return &(image[0]) + (cp.width * row_index);
}


#endif // __DATA_H__
