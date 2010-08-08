require 'rubygems'
require 'diff'
require 'colored'

class NiceDiff 
include Colored


	def diff (a,b)
		changes = Diff.new(a,b)
		d = []
		move = []
		o = b.dup
		copied_to = 0
		copied = []
		changes.compactdiffs.each{|e|
		#	puts e.inspect
			x = []
			y = []
			i = nil
			e.each {|f|
				if f.first == "-" then
					x = f[2]
				elsif f.first == "+"
					i = f[1]
					y = f[2]
				end
			}
			if i then
#				puts "replace: #{o[i].inspect}"
#				puts "with: #{y.inspect}"
#				puts i..(i + y.length - 1)
#				puts "copied_to: #{copied_to}" 
				k = copied_to
				
				while (k < i) do
					copied << o[k]
					k += 1
				end
				
				for j in i..(i + y.length - 1) 
					o[j] = nil
				end
				copied_to = i + y.length
				copied << [x,y]
				o[i] = [x,y]
#				puts "copied_updated: #{copied_to}" 

			end
		
		}
			k = copied_to
			while (k < o.length) do
				copied << o[k]
				k += 1
			end
#		puts o.inspect
#puts "COPIED: " + copied.inspect	
#		return o
		return copied
	end
	def join	(struct,with=" ")
		j = []
		s = ""
		first = true
		struct.each{|e|
			if e.is_a? String then
			s << with unless first
			s << e
			j << s unless j.include? s
			first = false
			elsif e.is_a? Array then
				s = ""
				j << join(e,with)
				first = true
			end
		}
	
		j	
	end
	def colour (diff_ary,with = " " )
		s = []
		diff_ary.each{|e|
			if e.is_a? String then
				s << e.blue
			else
			
				s << e.first.first.red if e.first.first
			end
		}	
		s.join(with)
	end


end


if __FILE__ == $0 then
	require 'diff/nice_diff'
	a = File.open(ARGV[0]).read.split(/(\W)/)
	b = File.open(ARGV[1]).read.split(/(\W)/)
	
	n = NiceDiff.new
	j = n.join(n.diff(a,b),"")
	puts j.inspect
	puts n.colour(n.diff(a,b),"")

end
