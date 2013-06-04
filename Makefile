run: copy_home copy_bin

copy_home:
	@cd home && find . | cpio -pud ~
	
copy_bin:
	@cd bin && find . | cpio -pud /usr/local/bin
