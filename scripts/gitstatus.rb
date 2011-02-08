#!/usr/bin/env ruby

@path = ARGV[0] ||= '.'

@bcolors = {
  :header => "\033[95m",
  :ok_blue => "\033[94m",
  :ok_green => "\033[92m",
  :warning => "\033[93m",
  :fail => "\033[91m",
  :endc => "\033[0m"
}

def repository?(filename)
  !filename.start_with?('.') and File.directory?(filename)
end

def check_uncommitted_and_unpushed
  status = `git status 2>&1 && git log origin/master..HEAD`
  not_gitrepo = (status =~ /fatal/)
  all_committed = (status =~ /nothing to commit/i)
  branch_ahead = (status =~ /Your branch is ahead/)
  if not_gitrepo
    print "#{@bcolors[:ok_blue]}not git repository.#{@bcolors[:endc]}\n"
  elsif not all_committed
    print "#{@bcolors[:warning]}uncommitted changes.#{@bcolors[:endc]}\n"
  elsif branch_ahead
    print "#{@bcolors[:warning]}unpushed commits.#{@bcolors[:endc]}\n"
  else
    print "#{@bcolors[:ok_green]}in sync.#{@bcolors[:endc]}\n"
  end
end

Dir.foreach(@path) { |filename|
  if repository?(filename)
    print "Checking #{filename}... "
    Dir.chdir(filename) do
      check_uncommitted_and_unpushed
    end
  end
}