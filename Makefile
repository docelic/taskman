all:
	make -B README INSTALL

README:
	./bin/taskman --tw 78 -H  > README

INSTALL:
	./bin/taskman --tw 78 --hinstall  > INSTALL

