AC_PREREQ([2.69])
AC_INIT([trendingvideos], [1.0], [])
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_SRCDIR([src/main.py])
AC_CONFIG_HEADERS([config.h])

# Checks for programs
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_MAKE_SET
AC_PROG_LIBTOOL

# Add libtool macros
AC_LIBTOOL_WIN32_DLL
AC_LIBTOOL_RC
LT_INIT
AC_SUBST([LIBTOOL_DEPS])

# Add the missing macro
m4_pattern_allow([LT_SYS_SYMBOL_USCORE])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT