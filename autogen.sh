#!/bin/sh
aclocal -I m4 || exit $?
autoconf || exit $?
