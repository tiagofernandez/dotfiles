all: copy-home copy-scripts set-defaults

copy-home:
	@cd home && find . | cpio -pud ~
	
copy-scripts:
	@cd scripts && find . | cpio -pud /usr/local/bin
	
set-defaults:
	chflags nohidden ~/Library/
	defaults write com.apple.finder AppleShowAllFiles true
	defaults write -g ApplePressAndHoldEnabled -bool false
	killall Finder
