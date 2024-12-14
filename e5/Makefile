BUILD_DIR = build

all: $(BUILD_DIR) etapa5

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/main.o: main.c | $(BUILD_DIR)
	gcc main.c -c -o $(BUILD_DIR)/main.o

$(BUILD_DIR)/table.o: table.c | $(BUILD_DIR)
	gcc table.c -c -o $(BUILD_DIR)/table.o

$(BUILD_DIR)/stack.o: stack.c | $(BUILD_DIR)
	gcc stack.c -c -o $(BUILD_DIR)/stack.o

$(BUILD_DIR)/iloc.o: iloc.c | $(BUILD_DIR)
	gcc iloc.c -c -o $(BUILD_DIR)/iloc.o

$(BUILD_DIR)/util.o: util.c | $(BUILD_DIR)
	gcc util.c -c -o $(BUILD_DIR)/util.o

$(BUILD_DIR)/asd.o: asd.c | $(BUILD_DIR)
	gcc asd.c -c -o $(BUILD_DIR)/asd.o

$(BUILD_DIR)/lex.yy.o: scanner.l | $(BUILD_DIR)
	flex scanner.l
	gcc -c lex.yy.c -o $(BUILD_DIR)/lex.yy.o

$(BUILD_DIR)/parser.tab.o: parser.y | $(BUILD_DIR)
	bison -d parser.y
	gcc -c parser.tab.c -o $(BUILD_DIR)/parser.tab.o

etapa5: $(BUILD_DIR)/parser.tab.o $(BUILD_DIR)/lex.yy.o $(BUILD_DIR)/asd.o $(BUILD_DIR)/util.o $(BUILD_DIR)/iloc.o $(BUILD_DIR)/stack.o $(BUILD_DIR)/table.o $(BUILD_DIR)/main.o
	gcc $(BUILD_DIR)/lex.yy.o $(BUILD_DIR)/parser.tab.o $(BUILD_DIR)/asd.o $(BUILD_DIR)/util.o $(BUILD_DIR)/iloc.o $(BUILD_DIR)/stack.o $(BUILD_DIR)/table.o $(BUILD_DIR)/main.o -o $(BUILD_DIR)/etapa5
