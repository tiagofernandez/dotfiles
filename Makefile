install: copy_home copy_scripts copy_settings

copy_home:
	@cd home && find . | cpio -pd ~
	
copy_scripts:
	@cd scripts && find . | cpio -pd /usr/local/bin

copy_settings_xcode:
	@mkdir -p ~/Library/Application\ Support/Xcode/Color\ Themes
	@cd settings/xcode && find . | cpio -pd ~/Library/Application\ Support/Xcode/Color\ Themes

copy_settings: copy_settings_xcode