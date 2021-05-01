doom:
	cd src; make

run:
	cd src; make run

debug:
	cd src; make debug

format:
	clang-format -i **/*.c **/*.h

clean:
	cd src; make clean
