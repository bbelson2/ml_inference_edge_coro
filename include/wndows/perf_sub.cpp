#include <pe_assist.h>

int peInitialize() { return 0; }
int peMakeGroup(int num, pid_t pid, int cpu, unsigned long flags) { return 0; }
int peAddLeader(long unsigned etype, long unsigned econfig) { return 0; }
int peAddEvent(long unsigned etype, long unsigned econfig) { return 0; }
int peStartCounting() { return 0; }
int peStopCounting() { return 0; }
int peResetCounters() { return 0; }
long long peReadCount(int eindex) { return 0; }
double peEventRatio(long long num, long long den) { return 0; }
double peEventPTI(long long num, long long instructions) { return 0.0; }
void pePrintCount(FILE* stream, int eindex, char* legend) {}

int peMeasureInstructionEvents() { return 0; }
int pePrintInstructionEvents() { return 0; }

int peMeasureDataAccessEvents() { return 0; }
int pePrintDataAccessEvents() { return 0; }

// CPU time measurement using clock()
void start_clock() {}
double get_clock_time() { return 0.0; }
void print_clock_time(FILE* stream, double time_in_seconds) {}

// #include <pe_cortex_a72.h>
void pe_event_collection_clear(pe_event_collection* c) {}
//int a72MeasureDataAccessEvents() { return 0; }
//void a72CollectDataAccessEvents(pe_event_collection* c) {}


extern "C" int pem_setup(int which) { return 0; }
extern "C" int pem_get_descriptor(int i, int* type, int* config, const char** name) { return 0; }

extern "C" int pem_start(void) { return 0; }
extern "C" int pem_stop(void) { return 0; }

extern "C" int pem_read_totals(int count, long long* buffer) { return 0; }
