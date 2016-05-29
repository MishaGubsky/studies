SOURCES = source/main.c
EXECUTABLE_DIR = bin
EXECUTABLE_NAME = now
EXECUTABLE_PATH = $(EXECUTABLE_DIR)/$(EXECUTABLE_NAME)


build: $(SOURCES)
	@mkdir -p $(EXECUTABLE_DIR)
	@gcc -std=gnu99 -o $(EXECUTABLE_PATH) $(SOURCES)

run: build
	@./$(EXECUTABLE_PATH)

stop:
	@pkill $(EXECUTABLE_NAME)
	@rm -rf /tmp/now.fifo

clean:
	@rm -rf /tmp/now.fifo
	@rm -rf $(EXECUTABLE_PATH)
