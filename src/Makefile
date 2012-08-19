ALLEGRO_MODULES = allegro-5.0 allegro_main-5.0 allegro_image-5.0

all:
	@mkdir -p build
	@objfw-compile --lib 0.0 -o objgamekit --builddir build *.m \
		--arc `pkg-config --cflags --libs ${ALLEGRO_MODULES}`

clean:
	@rm -fr build libobjgamekit.* *~
