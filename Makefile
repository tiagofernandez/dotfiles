install: home scripts settings

home:
	@cd home && find . | cpio -pud ~
	
scripts:
	@cd scripts && find . | cpio -pud /usr/local/bin

settings_eclipse:
	@mkdir -p ~/Library/Preferences/EclipseWorkspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/
	@cd settings/eclipse/colors/vibrantink/ && find org* | cpio -pud ~/Library/Preferences/EclipseWorkspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/

settings_intellij:
	@mkdir -p ~/Library/Preferences/IntelliJIdea10CE/
	@cd settings/intellij/ && find . | cpio -pud ~/Library/Preferences/IntelliJIdea10CE/

settings_xcode:
	@mkdir -p ~/Library/Application\ Support/Xcode/Color\ Themes/
	@cd settings/xcode/colors/ && find . | cpio -pud ~/Library/Application\ Support/Xcode/Color\ Themes/

settings: settings_eclipse settings_intellij settings_xcode