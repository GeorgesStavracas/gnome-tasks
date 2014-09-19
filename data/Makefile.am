NULL =

tasksappdir = $(datadir)/applications
tasksapp_in_files = tasks.desktop.in
tasksapp_DATA = $(tasksapp_in_files:.desktop.in=.desktop)

$(tasksapp_in_files): $(tasksapp_in_files:.desktop.in=.desktop.in.in)
	sed -e "s|\@VERSION\@|@VERSION@|" $< > $@

@INTLTOOL_DESKTOP_RULE@

appdatadir = $(datadir)/appdata
appdata_DATA = tasks.appdata.xml

icondir = $(datadir)/icons
icon_DATA = \
    icons/icon.png \
    icons/icon.svg

gsettingsschema_in_files = apps.tasks.gschema.xml.in
gsettings_SCHEMAS = $(gsettingsschema_in_files:.xml.in=.xml)
.PRECIOUS: $(gsettings_SCHEMAS)


@INTLTOOL_XML_NOMERGE_RULE@

@GSETTINGS_RULES@

EXTRA_DIST = 				    \
	tasks.desktop.in.in		\
	$(gsettingsschema_in_files)	\
	tasks.appdata.xml.in    \
	$(icon_DATA) \
	$(NULL)

CLEANFILES =	 			\
	$(tasksapp_in_files)	\
	$(tasksapp_DATA)		\
	$(gsettings_SCHEMAS)	\
	$(appdata_DATA)			\
	$(NULL)
