install: copy_home copy_scripts

copy_home:
	@cd home && find . | cpio -pud ~
	
copy_scripts:
	@cd scripts && find . | cpio -pud /usr/local/bin

copy_settings:
	@cd settings/sublime_text_2 && find . | cpio -pud ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User
	@cd settings/sublime_text && find . | cpio -pud ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User
