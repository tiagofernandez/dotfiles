install: copy_home copy_scripts settings

copy_home:
	@cd home && find . | cpio -pud ~
	
copy_scripts:
	@cd scripts && find . | cpio -pud /usr/local/bin

settings_eclipse:
	@mkdir -p ~/Library/Preferences/EclipseWorkspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/
	@cd settings/eclipse/colors/monokai/ && find org* | cpio -pud ~/Library/Preferences/EclipseWorkspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/

settings_intellij:
	@mkdir -p ~/Library/Preferences/IntelliJIdea10CE/
	@cd settings/intellij/ && find . | cpio -pud ~/Library/Preferences/IntelliJIdea10CE/

settings_xcode:
	@mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes/
	@cd settings/xcode/colors/ && find . | cpio -pud ~/Library/Developer/Xcode/UserData/FontAndColorThemes/

settings: settings_eclipse settings_intellij settings_xcode