#require 'library'

module Coupler2
	attr_accessor :parent
	require 'library'
	#def class_couple(sym)
		#eval
		#ClassCoupler.new(sym,self)
	#end
	def to_klass (sym)
		puts "eval #{sym.to_s}"
		eval sym.to_s
	end
	
	def is_ident? (klass)
		klass.is_a? Symbol or klass.is_a? String
	end
	
	def couple(test)
		test = to_key(test)	
		@couples ||={}
		if c = @couples[test] then
			return to_klass(c)
		elsif @parent then
			return @parent.couple(test)
		elsif self != Library.library
			puts "Default to library's couplings for:#{test}"
			raise "LIBRARTY NOT ADAPTED FOR COUPLER2"
			#Library.library.couple(test)
		else
			raise("#{self} don't have anything to couple to #{test}")
		end
	end

	def to_key (test)
		unless is_ident? test then
			test = test.name.to_sym
		else 
			test = test.to_sym
		end
		test 
	end	
		#remove the last one
	def couplex(test,_klass)
		@couples ||={}
		@couples[to_key(test)] = to_key(_klass)
		self
	end
end

