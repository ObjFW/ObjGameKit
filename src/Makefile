all:
	@mkdir -p build
	@objfw-compile --lib 0.0 -o objgamekit --builddir build *.m \
		--arc `pkg-config --cflags --libs allegro-5.0 allegro_main-5.0`

clean:
	@rm -fr build libobjgamekit.* *~
