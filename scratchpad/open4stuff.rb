  require "rubygems"
 require 'open4'

    status =
      Open4::popen4("sh") do |pid, stdin, stdout, stderr|
        stdin.puts "echo 42.out"
        stdin.puts "echo 42.err 1>&2"
        stdin.close

        puts "pid        : #{ pid }"
        puts "stdout     : #{ stdout.read.strip }"
        puts "stderr     : #{ stderr.read.strip }"
      end

        puts "status     : #{ status.inspect }"
        puts "exitstatus : #{ status.exitstatus }"
