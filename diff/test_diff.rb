require 'test_sl'

include TestSL

TestDiff2 = test_group(:TestDiff) {
	test(:compare_same) {
		x = args.first.new
		d = x.diff("hello my name is Ben".split(" "),"hello my name is Ben".split(" "))

		g = %w{hello my name is Ben}
		
		raise "\n#{d.inspect} should be #{g.inspect}" unless d == g
	}

	test(:compare_str) {
		x = args.first.new

		d = x.diff("hello my name is Ben".split(" "),"hello my name is James".split(" "))
		g = ["hello","my","name","is",[["Ben"],["James"]]]
		raise "\n#{d.inspect} should be #{g.inspect}" unless d == g
		j = ["hello my name is",[["Ben"],["James"]]]
		e = x.join(d)
		raise "\n#{e.inspect} should be #{j.inspect}" unless e == j
		
	}
	test(:diff_insert){
		x = args.first.new
		a = [:same,:same,:same]
		b = [:same,:same,:DELETE,:same]
		
		d = x.diff(a,b)
		g = [:same,:same,[[],[:DELETE]],:same]
	
		raise "\n#{d.inspect} should be #{g.inspect}" unless d == g
	}
	test(:join2){
#		a = "Following the September 11, 2001 attacks, George W. Bush responded by declaring a global War on Terrorism".split(/\s/)
#		b = "Eight months into Bush's first term as president, the September 11, 2001, terrorist attacks occurred. In response, Bush announced a global War on Terrorism".split(/\s/)
		a = "George W. Bush responded by declaring a global War on Terrorism".split(/(\s)/)
		b = "In response, Bush announced a global War on Terrorism".split(/(\s)/)
		x = args.first.new
		y =  x.diff(a,b)
	#	puts y.inspect
	#	puts 
	#	puts x.join(y).inspect
		puts x.colour(x.join(y,""),"")

		#puts x.colour(x.join(x.diff(a,a)))
				
	}

}

if __FILE__ == $0 then
	require 'diff/nice_diff'
	TestDiff2.run(NiceDiff)

end
