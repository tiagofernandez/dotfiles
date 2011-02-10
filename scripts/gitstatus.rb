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
  if (status =~ /fatal/)
    print "not git repository."
  else
    if not (status =~ /nothing to commit/i)
      print "#{@bcolors[:warning]}uncommitted changes.#{@bcolors[:endc]}\n"
    elsif (status =~ /Your branch is ahead/)
      print "#{@bcolors[:warning]}unpushed commits.#{@bcolors[:endc]}\n"
    else
      print "#{@bcolors[:ok_green]}in sync.#{@bcolors[:endc]}\n"
    end
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