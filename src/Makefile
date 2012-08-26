SHARED_LIB = ${LIB_PREFIX}objgamekit${LIB_SUFFIX}
LIB_MAJOR = 0
LIB_MINOR = 0

SRCS = OGKBitmap.m	\
       OGKDisplay.m	\
       OGKEvent.m	\
       OGKEventQueue.m

INCLUDES = ${SRCS:.m=.h}	\
	   ObjGameKit.h

include ../buildsys.mk
include ../extra.mk

CPPFLAGS += -DOGK_INTERNAL
LD = ${OBJC}
LDFLAGS += ${REEXPORT_ALLEGRO}
