all: README_B

README_B:
	make -B README

README:
	./bin/taskman --tw 78 -H  > README

