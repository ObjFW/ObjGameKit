SHARED_LIB = ${LIB_PREFIX}objgamekit${LIB_SUFFIX}
LIB_MAJOR = 0
LIB_MINOR = 0

SRCS = OGKBitmap.m	\
       OGKDisplay.m	\
       OGKEvent.m	\
       OGKEventQueue.m

INCLUDES = ${SRCS:.m=.h}

include ../buildsys.mk

CPPFLAGS += -DOGK_INTERNAL
LD = ${OBJC}
