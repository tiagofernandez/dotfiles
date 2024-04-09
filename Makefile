all: copy-home set-defaults

copy-home:
	@cd home && find . | cpio -pud ~
	
set-defaults:
	chflags nohidden ~/Library/
	defaults write com.apple.finder AppleShowAllFiles true
	defaults write -g ApplePressAndHoldEnabled -bool false
	killall Finder
