all: README_B

README_B:
	make -B README

README:
	./bin/taskman.manual --tw 78 -H  > README

