HEADERS = sources/monitor.h
SOURCES = sources/monitor.c sources/main.c

EXECUTABLE = monitor
EXECUTABLE_PATH = bin/$(EXECUTABLE)


stop:
	@-pkill $(EXECUTABLE); true

build: stop
	@mkdir -p bin
	@gcc -std=gnu99 $(HEADERS) $(SOURCES) -o $(EXECUTABLE_PATH)

run: build
	@./$(EXECUTABLE_PATH)
	@ps -A | grep $(EXECUTABLE)

help: build
	@./$(EXECUTABLE_PATH) --help

pid:
	ps -A | grep $(EXECUTABLE)

clean:
	@rm -rf *.o *.log $(EXECUTABLE_PATH)
