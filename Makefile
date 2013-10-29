run: copy_home copy_bin copy_ssh

copy_home:
	@cd home && find . | cpio -pud ~
	
copy_bin:
	@cd bin && find . | cpio -pud /usr/local/bin

copy_ssh:
	@cd .ssh && find . | cpio -pud ~/.ssh
