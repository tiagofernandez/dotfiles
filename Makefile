install: copy_home copy_scripts

copy_home:
	@cd home && find . | cpio -pd ~
	
copy_scripts:
	@cd scripts && find . | cpio -pd /usr/local/bin