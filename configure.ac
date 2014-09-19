dnl -*- mode: m4 -*-
AC_PREREQ([2.67])
AC_INIT([gnome-tasks],
        [0.0.1],
        [https://github.com/GeorgesStavracas/gnome-tasks/issues],
        [gnome-tasks])

AM_INIT_AUTOMAKE([1.11 tar-ustar dist-xz no-dist-gzip])

AC_CONFIG_HEADERS(config.h)
AC_CONFIG_SRCDIR(src/main.vala)
AC_CONFIG_MACRO_DIR([m4])

AC_SEARCH_LIBS([strerror],[cposix])
AC_PROG_CC
AC_HEADER_STDC
AC_FUNC_MMAP

AM_MAINTAINER_MODE([enable])
AM_SILENT_RULES([yes])

# Setup gettext (l10n & i18n)
IT_PROG_INTLTOOL(0.40.0)

AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.17])

GETTEXT_PACKAGE=gnome-tasks
AC_SUBST([GETTEXT_PACKAGE])
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE",[Gettext Package])

# Initialize libtool
LT_PREREQ([2.2])
LT_INIT([dlopen disable-static])

AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_MAKE_SET
dnl Check for vala
AM_PROG_VALAC([0.23.0])


# compile gsettings schemas
GLIB_GSETTINGS

# Resources 
GLIB_COMPILE_RESOURCES=`$PKG_CONFIG --variable glib_compile_resources gio-2.0`
AC_SUBST(GLIB_COMPILE_RESOURCES)

package_modules="
    gee-0.8
    gio-2.0 >= 2.36
    glib-2.0 >= 2.36
    gmodule-2.0
    gobject-2.0
    gtk+-3.0 >= 3.9.11
    libnotify
    libpeas-1.0
    libpeas-gtk-1.0
		sqlite3"

PKG_CHECK_MODULES(TASKS, [$package_modules])

TASKS_PACKAGES=" \
    --pkg gtk+-3.0 \
    --pkg gio-2.0 \
    --pkg gobject-2.0 \
    --pkg gmodule-2.0 \
    --pkg glib-2.0 \
    --pkg libpeas-1.0 \
    --pkg libpeas-gtk-1.0 \
    --pkg sqlite3"

AC_SUBST(TASKS_PACKAGES)

dnl Add plugins
#TASKS_ADD_PLUGIN([example],[Example],[yes])
#TASKS_ADD_PLUGIN([local-source],[Local Source],[yes])

dnl Setup vala stamps
TASKS_ADD_STAMP([src/tasks_vala.stamp])

# Setup plugin dependencies
PKG_CHECK_MODULES([TASKS_PLUGIN_DEPS], [$package_modules])

# Defining some constant paths
AC_SUBST([TASKS_PLUGIN_DIR], [${libdir}/tasks-1.0/plugins])
AC_SUBST([TASKS_PLUGIN_LINKER_FLAGS], ["-module -avoid-version -Wl,-z,defs"])

AC_CONFIG_FILES([
    Makefile
    tasks-1.0.pc
    data/Makefile
    data/apps.tasks.gschema.xml.in
    src/Makefile
    po/Makefile.in
])

AC_OUTPUT


echo "

    GNOME Tasks $VERSION

    Prefix: ${prefix}
    Vala compiler: ${VALAC}
    C compiler: ${CC}
    Plugin deps: ${TASKS_PLUGIN_DEPS_LIBS}

    Now type 'make' to build $PACKAGE
"
