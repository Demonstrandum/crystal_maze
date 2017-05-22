COMP = crystal
FLAGS  = build --release
TARGET = maze
DEST = /usr/local/bin

all:
	@echo "Compiling $(TARGET).cr..."
	$(COMP) $(FLAGS) -o bin/$(TARGET) src/$(TARGET).cr

install:
	@echo "Copying $(TARGET) to $(DEST)..."
	cp bin/$(TARGET) $(DEST)

clean:
	@echo "Removing '$(TARGET)' binary from current directory"
	rm -f bin/$(TARGET)

uninstall:
	@echo "Removing binary from $(DEST)"
	rm -f $(DEST)/$(TARGET)
