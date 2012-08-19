ALLEGRO_MODULES = allegro-5.0 allegro_main-5.0 allegro_image-5.0

all:
	@objfw-compile -o test --arc *.m \
		-I../src -L../src -lobjgamekit \
		`pkg-config --cflags --libs ${ALLEGRO_MODULES}`

clean:
	@rm -f test *.o *~
