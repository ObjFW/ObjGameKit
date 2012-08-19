all:
	@cd src && ${MAKE} ${MFLAGS}
	@cd test && ${MAKE} ${MFLAGS}

clean:
	@cd src && ${MAKE} ${MFLAGS} clean
	@cd test && ${MAKE} ${MFLAGS} clean
	@rm -f *~
