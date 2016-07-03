CC=valac
VERSION=0.1
LIBRARY=vmath
CFLAGS= --library=$(LIBRARY) -H $(LIBRARY).h --pkg gee-0.8 --gir=$(LIBRARY)-$(VERSION).gir
SOURCES=$(wildcard *.vala)

all:
	$(CC) $(CFLAGS) $(SOURCES) -X -fPIC -X -shared -o lib$(LIBRARY).so
	g-ir-compiler --shared-library=lib$(LIBRARY).so --output=$(LIBRARY)-$(VERSION).typelib $(LIBRARY)-$(VERSION).gir
	./test

clean:
	rm -f *.gir *.typelib *.so *.vapi *.tmp *.h
