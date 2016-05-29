SOURCES = sources/main.c
EXECUTABLE = date
EXECUTABLE_DIR = bin
EXECUTABLE_PATH = $(EXECUTABLE_DIR)/$(EXECUTABLE)


build:
	@mkdir -p $(EXECUTABLE_DIR)
	@gcc -std=gnu99 -pthread $(SOURCES) -o $(EXECUTABLE_PATH)

run: build
	@./$(EXECUTABLE_PATH)

clean:
	@rm -rf *.o *.log $(EXECUTABLE_PATH)
