AM_CPPFLAGS = \
  -I$(top_builddir)/libtasks \
	-I$(top_srcdir)/libtasks \
	-I$(srcdir) \
	-DGNOME_DESKTOP_USE_UNSTABLE_API \
	-DGETTEXT_PACKAGE=\""$(GETTEXT_PACKAGE)"\" \
	-DPLUGINDIR=\""$(TASKS_PLUGIN_DIR)"\" \
	-DGNOMELOCALEDIR=\""$(localedir)"\" \
  -DDATADIR=\""$(pkgdatadir)"\"

AM_CFLAGS = \
    -g \
	$(TASKS_CFLAGS)

bin_PROGRAMS = tasks

BUILT_SOURCES = tasks-resources.c

# source code
VALA_SOURCES = \
    main.vala \
    tasks-application.vala \
    tasks-plugin-manager.vala \
    tasks-window.vala

tasks_SOURCES = \
    $(VALA_SOURCES) \
    config.vapi \
    $(BUILT_SOURCES)

# compile-time dependencies
tasks_VALAFLAGS =  \
    @TASKS_PACKAGES@ \
    --target-glib=2.38 \
    --gresources=tasks.gresource.xml

tasks_LDFLAGS = \
	-export-dynamic

tasks_LDADD = $(TASKS_LIBS) -lm

# generate binary-bundle resources
resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(srcdir) $(srcdir)/tasks.gresource.xml)
    
tasks-resources.c: tasks.gresource.xml $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(srcdir) --generate-source $<

EXTRA_DIST= \
    $(resource_files) \
    tasks.gresource.xml

MAINTAINERCLEANFILES = \
	*.stamp	\
	$(VALA_SOURCES:.vala=.c) \
	$(BUILT_SOURCES)
    

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

