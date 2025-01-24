# Makefile stucture
#
# <target> : <dependency>
# (tab)<Recipe>

a.out : a.o b.o main.o
	gcc -o a.out a.o b.o main.o
    
a.o : a.c
	gcc -c -o a.o a.c
    
b.o : b.c
	gcc -c -o b.o b.c
    
main.o : main.c
	gcc -c -o main.o main.c
    
clean:
	rm *.o a.out
