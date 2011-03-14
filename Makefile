install: copy_home copy_scripts

copy_home:
	@cd home && find . | cpio -pud ~
	
copy_scripts:
	@cd scripts && find . | cpio -pud /usr/local/bin