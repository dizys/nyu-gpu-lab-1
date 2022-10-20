.PHONY: clean

all: vectorprog testprog

vectorprog: vectors.cu
	nvcc -o vectorprog vectors.cu -lm

testprog: test.cu
	nvcc -o testprog test.cu -lm

clean:
	rm -f vectorprog testprog
