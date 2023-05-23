all: copy-home set-defaults

copy-home:
	@cd copy-home && find . | cpio -pud ~
	
set-defaults:
	chflags nohidden ~/Library/
	defaults write com.apple.finder AppleShowAllFiles true; killall Finder
	defaults write -g ApplePressAndHoldEnabled -bool false
