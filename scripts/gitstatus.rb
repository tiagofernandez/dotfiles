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

Dir.foreach(@path) { |filename|
  if repository?(filename)
    print "Checking #{filename}... "
    Dir.chdir(filename) do
      status = `git status 2>&1`
      if status =~ /fatal|nothing to commit \(working directory clean\)/i
        print "#{@bcolors[:ok_green]}ok!#{@bcolors[:endc]}\n"
      else
        print "#{@bcolors[:warning]}not ok!#{@bcolors[:endc]}\n"
      end
    end
  end
}