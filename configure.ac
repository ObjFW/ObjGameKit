AC_INIT(ObjGameKit, 0.1, js@webkeks.org)
AC_CONFIG_SRCDIR(src)

AC_CANONICAL_HOST

AC_CHECK_TOOL(OBJFW_CONFIG, objfw-config)
AS_IF([test x"$OBJFW_CONFIG" = x""], [
	AC_MSG_ERROR(You need ObjFW and objfw-config installed!)
])

test x"$OBJC" = x"" && OBJC="$($OBJFW_CONFIG --objc)"

AC_LANG([Objective C])
AC_PROG_OBJC
AC_PROG_OBJCPP
AC_PROG_LN_S
AC_PROG_INSTALL

CPP="$OBJCPP"
CPPFLAGS="$CPPFLAGS $OBJCPPFLAGS $($OBJFW_CONFIG --cppflags)"
OBJCFLAGS="$OBJCFLAGS -Wall $($OBJFW_CONFIG --objcflags)"
LDFLAGS="$LDFLAGS $($OBJFW_CONFIG --ldflags)"
LIBS="$LIBS $($OBJFW_CONFIG --libs)"

OBJCFLAGS="$OBJCFLAGS $($OBJFW_CONFIG --arc)"
AC_MSG_CHECKING([whether Objective C compiler supports ARC])
AC_TRY_COMPILE([
	#if !__has_feature(objc_arc)
	# error No ARC
	#endif
	@interface Test
	@end
], [
	__unsafe_unretained Test *t;
], [
	AC_MSG_RESULT(yes)
], [
	AC_MSG_RESULT(no)
	AC_MSG_ERROR(You need an Objective C compiler with ARC support!)
])

PKG_CHECK_MODULES(allegro5, [allegro-5.0 allegro_main-5.0 allegro_image-5.0], [
	CPPFLAGS="$CPPFLAGS $allegro5_CFLAGS"
	LIBS="$LIBS $allegro5_LIBS"
], [
	AC_MSG_ERROR(You need allegro{_main,_image}-5.0 installed!)
])

case "$host_os" in
	darwin*)
		AC_SUBST(REEXPORT_ALLEGRO, ["-Wl,-reexport-lallegro_main"])
		;;
esac

# We add -Werror after all tests in case some tests emit warnings
OBJCFLAGS="$OBJCFLAGS -Werror"

BUILDSYS_SHARED_LIB
BUILDSYS_INIT
BUILDSYS_TOUCH_DEPS

dnl We don't call AC_PROG_CPP, but only AC_PROG_OBJCPP and set CPP to OBJCPP
dnl and add OBJCPPFLAGS to CPPFLAGS, thus we need to AC_SUBST these ourself.
AC_SUBST(CPP)
AC_SUBST(CPPFLAGS)

AC_SUBST(PACKAGE, ObjGameKit)
AC_CONFIG_FILES([buildsys.mk extra.mk])
AC_OUTPUT
