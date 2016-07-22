LIBDIR=/usr/lib
INCDIR=/usr/include
VAPIDIR=/usr/share/vala/vapi
TYPELIBDIR=/usr/lib/girepository-1.0

VERSION=0.1
LIBRARY=vmath

CC=valac
CFLAGS= --library=$(LIBRARY)-$(VERSION) -H $(LIBRARY).h --pkg gee-0.8 --gir=$(LIBRARY)-$(VERSION).gir -g --save-temps
SOURCES=$(wildcard src/*.vala)

all:
	$(CC) $(CFLAGS) $(SOURCES) -X -fPIC -X -shared -o lib$(LIBRARY)-$(VERSION).so

clean:
	rm -f *.gir *.typelib *.so *.vapi *.tmp *.h
	rm src/*.c
	rm -rfd docs

install:
	sudo cp lib$(LIBRARY)-$(VERSION).so $(LIBDIR)
	sudo cp $(LIBRARY).h $(INCDIR)
	sudo cp $(LIBRARY)-$(VERSION).vapi $(VAPIDIR)
	sudo cp $(LIBRARY)-$(VERSION).typelib $(TYPELIBDIR)

c:
	$(CC) -C $(CFLAGS) $(SOURCES)

typelib:
	g-ir-compiler --shared-library=lib$(LIBRARY)-$(VERSION).so --output=$(LIBRARY)-$(VERSION).typelib $(LIBRARY)-$(VERSION).gir

docs:
	valadoc -o docs --pkg gee-0.8 --package-name $(LIBRARY) $(SOURCES)
