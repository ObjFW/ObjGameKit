all:
	@objfw-compile -o test --arc *.m \
		-I../src -L../src -lobjgamekit \
		`pkg-config --cflags --libs allegro-5.0 allegro_main-5.0`

clean:
	@rm -f test *.o *~
