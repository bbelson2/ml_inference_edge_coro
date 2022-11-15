OS := $(shell uname)
MACHINE := $(shell uname -m)
TOOLSET := gcc

# Make build settings dependent on platform/architecture
ifeq ($(TOOLSET),llvm)
	ifeq ($(MACHINE),x86_64)
		# Ubuntu
		CPP=/usr/bin/clang++-12
		CPP_FLAGS=-I../include -std=c++2a -stdlib=libc++ -Wall -pedantic -fcoroutines-ts -O3 -DMACHINE=x86_64 
#-v -D __cpp_impl_coroutine
		CC=/usr/bin/clang-12
		CC_FLAGS=-I../include -Wall -pedantic -O3 -DMACHINE=x86_64
		LD_FLAGS=-std=c++20 -stdlib=libc++
		PE_FOR_PLAT=pe_intel_x64
	else
		# Raspi 4
		# Note that the following are required in the build session
		#   export PATH=/usr/local/clang_12.0.1/bin:$PATH
		#   export LD_LIBRARY_PATH=/usr/local/clang_12.0.1/lib:$LD_LIBRARY_PATH
		CPP=clang++
		CPP_FLAGS=-I../include -std=c++2a -stdlib=libc++ -Wall -pedantic -fcoroutines-ts -O3 -DMACHINE=rp2040
		CC=clang
		CC_FLAGS=-I../include -Wall -pedantic -O3 -DMACHINE=raspi4
		LD_FLAGS=-std=c++20 -stdlib=libc++
		PE_FOR_PLAT=pe_cortex_a72
	endif
endif
ifeq ($(TOOLSET),gcc)
	ifeq ($(MACHINE),x86_64)
		# Ubuntu
		CPP=/usr/bin/g++-10
		CPP_FLAGS=-I../include -std=c++20 -Wall -pedantic -fcoroutines -O3 -DMACHINE=x86_64 
		#CPP_FLAGS=-I../include -std=c++20 -Wall -fcoroutines -O3
		CC=/usr/bin/gcc-10
		CC_FLAGS=-I../include -Wall -pedantic -O3 -DMACHINE=x86_64
		LD_FLAGS=
		PE_FOR_PLAT=pe_intel_x64
	else
		# Raspi 4
		CPP=/opt/native-pi-gcc-10.2.0-2/bin/g++-10.2.0
		CPP_FLAGS=-I../include -std=c++20 -Wall -pedantic -fcoroutines -O3 -DMACHINE=rp2040 -fcompare-debug-second
		#CPP_FLAGS=-I../include -std=c++20 -Wall -fcoroutines -O3
		CC=/opt/native-pi-gcc-10.2.0-2/bin/gcc-10.2.0
		CC_FLAGS=-I../include -Wall -pedantic -O3 -DMACHINE=raspi4
		LD_FLAGS=
		PE_FOR_PLAT=pe_cortex_a72
	endif
endif

MKDIR_P = mkdir -p
OUT_DIR=../output/$(TOOLSET)

.PHONY: directories

all:	directories programs

programs: $(OUT_DIR)/svm.out $(OUT_DIR)/svm32.out \
		$(OUT_DIR)/svmf32.out $(OUT_DIR)/svmf64.out \
		$(OUT_DIR)/visit.out \
		$(OUT_DIR)/leaf.out \
		$(OUT_DIR)/norm.out $(OUT_DIR)/norm32.out \
		$(OUT_DIR)/normf32.out $(OUT_DIR)/normf64.out \
		$(OUT_DIR)/rndleaf.out \
		$(OUT_DIR)/cnn.out $(OUT_DIR)/cnn32.out \
		$(OUT_DIR)/cnnf32.out $(OUT_DIR)/cnnf64.out \

directories: $(OUT_DIR)

test:	test_args \

STD_INCLUDES = ../include/resumable.h ../include/pe_monitor.h ../include/pe_monitor_coll.h ../include/fixed_point.h calc_core.h cmd_line.h context.h data.h execution_models.h execution_models_impl.h perf_rec.h pe_summaries.h report.h 

$(OUT_DIR)/pe_monitor.o: ../perf/pe_monitor.c ../include/pe_monitor.h
	$(CPP) -g -c ../perf/pe_monitor.c $(CC_FLAGS) -o $(OUT_DIR)/pe_monitor.o

$(OUT_DIR)/svm.o:	svm.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./svm.cpp $(CPP_FLAGS) -o $(OUT_DIR)/svm.o

$(OUT_DIR)/svm.out: $(OUT_DIR)/svm.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/svm.out $(OUT_DIR)/svm.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/svm32.o:	svm.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./svm.cpp $(CPP_FLAGS) -DFIXED_POINT_BITS=32  -o $(OUT_DIR)/svm32.o

$(OUT_DIR)/svm32.out: $(OUT_DIR)/svm32.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/svm32.out $(OUT_DIR)/svm32.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/svmf32.o:	svmf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./svmf.cpp $(CPP_FLAGS) -o $(OUT_DIR)/svmf32.o -DFLOATING_POINT_BITS=32

$(OUT_DIR)/svmf32.out: $(OUT_DIR)/svmf32.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/svmf32.out $(OUT_DIR)/svmf32.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/svmf64.o:	svmf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./svmf.cpp $(CPP_FLAGS) -o $(OUT_DIR)/svmf64.o -DFLOATING_POINT_BITS=64

$(OUT_DIR)/svmf64.out: $(OUT_DIR)/svmf64.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/svmf64.out $(OUT_DIR)/svmf64.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/visit.o:	visit.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./visit.cpp $(CPP_FLAGS) -o $(OUT_DIR)/visit.o

$(OUT_DIR)/visit.out: $(OUT_DIR)/visit.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/visit.out $(OUT_DIR)/visit.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/leaf.o:	leaf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./leaf.cpp $(CPP_FLAGS) -o $(OUT_DIR)/leaf.o

$(OUT_DIR)/leaf.out: $(OUT_DIR)/leaf.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/leaf.out $(OUT_DIR)/leaf.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/norm.o:	norm.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./norm.cpp $(CPP_FLAGS)  -o $(OUT_DIR)/norm.o

$(OUT_DIR)/norm.out: $(OUT_DIR)/norm.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/norm.out $(OUT_DIR)/norm.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/norm32.o:	norm.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./norm.cpp $(CPP_FLAGS) -DFIXED_POINT_BITS=32  -o $(OUT_DIR)/norm32.o

$(OUT_DIR)/norm32.out: $(OUT_DIR)/norm32.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/norm32.out $(OUT_DIR)/norm32.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/normf32.o:	normf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./normf.cpp $(CPP_FLAGS) -DFLOATING_POINT_BITS=32  -o $(OUT_DIR)/normf32.o

$(OUT_DIR)/normf32.out: $(OUT_DIR)/normf32.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/normf32.out $(OUT_DIR)/normf32.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/normf64.o:	normf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./normf.cpp $(CPP_FLAGS) -DFLOATING_POINT_BITS=64  -o $(OUT_DIR)/normf64.o

$(OUT_DIR)/normf64.out: $(OUT_DIR)/normf64.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/normf64.out $(OUT_DIR)/normf64.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/rndleaf.o:	rndleaf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./rndleaf.cpp $(CPP_FLAGS) -o $(OUT_DIR)/rndleaf.o

$(OUT_DIR)/rndleaf.out: $(OUT_DIR)/rndleaf.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/rndleaf.out $(OUT_DIR)/rndleaf.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/cnn.o:	cnn.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./cnn.cpp $(CPP_FLAGS) -o $(OUT_DIR)/cnn.o

$(OUT_DIR)/cnn.out: $(OUT_DIR)/cnn.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/cnn.out $(OUT_DIR)/cnn.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/cnn32.o:	cnn.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./cnn.cpp $(CPP_FLAGS) -DFIXED_POINT_BITS=32 -o $(OUT_DIR)/cnn32.o

$(OUT_DIR)/cnn32.out: $(OUT_DIR)/cnn32.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/cnn32.out $(OUT_DIR)/cnn32.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/cnnf32.o:	cnnf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./cnnf.cpp $(CPP_FLAGS) -o $(OUT_DIR)/cnnf32.o -DFLOATING_POINT_BITS=32

$(OUT_DIR)/cnnf32.out: $(OUT_DIR)/cnnf32.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/cnnf32.out $(OUT_DIR)/cnnf32.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR)/cnnf64.o:	cnnf.cpp $(STD_INCLUDES)
	$(CPP) -g -c ./cnnf.cpp $(CPP_FLAGS) -o $(OUT_DIR)/cnnf64.o -DFLOATING_POINT_BITS=64

$(OUT_DIR)/cnnf64.out: $(OUT_DIR)/cnnf64.o $(OUT_DIR)/pe_monitor.o
	$(CPP) -o $(OUT_DIR)/cnnf64.out $(OUT_DIR)/cnnf64.o $(OUT_DIR)/pe_monitor.o $(LD_FLAGS)

$(OUT_DIR): 
	${MKDIR_P} ${OUT_DIR}

test_args: 
	echo TOOLSET=$(TOOLSET)
