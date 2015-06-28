FC=ifort
FLAGS= -O3

all:
	${FC} ${FLAGS} main.f90
	./a.out

clean:
	rm -rf ./a.out
