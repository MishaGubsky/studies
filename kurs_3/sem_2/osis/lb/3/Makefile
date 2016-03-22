all: third

third: main.o morze.o
	gcc main.o morze.o -o third 

main.o: main.c
	gcc -c main.c

morze.o: morze.c
	gcc -c morze.c

test:
	./third
	diff output.txt output-expected.txt

clean:
	rm -rf *.o third