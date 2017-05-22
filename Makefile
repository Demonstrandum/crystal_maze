COMP = crystal
FLAGS  = build --release
TARGET = maze
DEST = /usr/local/bin
all: $(TARGET)
$(TARGET): $(TARGET).cr
	@echo "Compiling $(TARGET).cr..."
	$(COMP) $(FLAGS) -o $(TARGET) $(TARGET).cr

install:
	@echo "Copying $(TARGET) to $(DEST)..."
	cp $(TARGET) $(DEST)

clean:
	@echo "Removing '$(TARGET)' binary from current directory"
	rm -f $(TARGET)

uninstall:
	@echo "Removing binary from $(DEST)"
	rm -f $(DEST)/$(TARGET)
