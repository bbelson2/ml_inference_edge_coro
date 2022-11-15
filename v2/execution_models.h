#pragma once

#ifndef __EXECUTION_MODELS_H__
#define __EXECUTION_MODELS_H__

#define EMN_CONTROL "control"
#define EMN_MANAGED_NOPREFETCH "managed-no-prefetch"
#define EMN_MANAGED_PREFETCH "managed-prefetch"
#define EMN_PROTO_NOPREFETCH "proto-no-prefetch"
#define EMN_PROTO_PREFETCH "proto-prefetch"
#define EMN_CORO_NOPREFETCH "coro-no-prefetch"
#define EMN_CORO_PREFETCH "coro-prefetch"

enum EMI_SUMMARIES
{
  EMI_CONTROL = 0,
  EMI_MANAGED_NOPREFETCH,
  EMI_MANAGED_PREFETCH,
  EMI_PROTO_NOPREFETCH,
  EMI_PROTO_PREFETCH,
  EMI_CORO_NOPREFETCH,
  EMI_CORO_PREFETCH,

  EMI_COUNT = 7
};

const char *summary_names[] = {
    EMN_CONTROL,
    EMN_MANAGED_NOPREFETCH,
    EMN_MANAGED_PREFETCH,
    EMN_PROTO_NOPREFETCH,
    EMN_PROTO_PREFETCH,
    EMN_CORO_NOPREFETCH,
    EMN_CORO_PREFETCH,
};

void calculate_included_summaries(bool fast, int control_model_index, bool* control_models)
{
  if (fast)
  {
    control_models[EMI_CONTROL] = true;
    control_models[EMI_MANAGED_NOPREFETCH] = false;
    control_models[EMI_MANAGED_PREFETCH] = false;
    control_models[EMI_PROTO_NOPREFETCH] = false;
    control_models[EMI_PROTO_PREFETCH] = false;
    control_models[EMI_CORO_NOPREFETCH] = true;
    control_models[EMI_CORO_PREFETCH] = true;
  }
  else
  {
    if (control_model_index == -1) {
      for (int i = 0; i < EMI_COUNT; i++) {
        control_models[i] = true;
      }
    }
    else {
      for (int i = 0; i < EMI_COUNT; i++) {
        control_models[i] = (i == control_model_index);
      }
    }
  }
}

#endif // __EXECUTION_MODELS_H__
