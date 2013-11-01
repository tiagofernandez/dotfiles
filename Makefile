run: home bin fish

home:
	@cd home && find . | cpio -pud ~
	
bin:
	@cd bin && find . | cpio -pud /usr/local/bin

fish:
	mkdir -p ~/.config/fish/completions
	ln -s (brew --prefix)/Library/Contributions/brew_fish_completion.fish ~/.config/fish/completions/brew.fish
	curl --create-dirs -o ~/.config/fish/completions/pyenv.fish https://raw.github.com/yyuu/pyenv/master/completions/pyenv.fish
	curl --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish
