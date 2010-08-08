#require 'library'

class Object #it's nasty but it must be done
	alias  __is_a? is_a?
	def is_a?(other)
			self.__is_a? other.respond_to?(:__wrapped__) ? 
			(other.__wrapped__ || other) : 
			other
	end
end

class Class
def __wrapped__; nil; end

alias  __equal? equal?
alias  __trip_eql? ===

def === other
		self.__trip_eql? other.respond_to?(:__wrapped__) ? (other.__wrapped__ || other) : other
end

def equal? (other)
	#if other.__wrapped__ then
	#	other.equal? self
	#else
	#	self.__equal?(other)
	#end
	self.__equal?(other.respond_to?(:__wrapped__) ? (other.__wrapped__ || other) : other)
end

def == (other)
	equal? (other)
end
def eql? (other)
	equal?(other)
end
end

module Coupler

	class ClassCoupler
		include Coupler
		alias __instance_eval__ instance_eval
		
	   instance_methods.reject {|method|
		   /__.*__/ === method or /couplex?/ =~ method or 'inspect' == method or 'to_s' == method
		}.each {|method|
			undef_method(method)
		}
		def __wrapped__
			@wrapped
		end
		def initialize (wrap,parent = nil,&block)
			#puts "#INITIALIZE!"
	   	@wrapped = wrap
	   	@parent = parent 
	   	__instance_eval__ &block if block
	   end
		def method_missing(m_name, *args, &block)
			#puts "CALL:#{m_name}"
			@wrapped.method(m_name).call(*args, &block)
		end
	end
	require 'library'
	def couple(test)
		if test.is_a? Symbol then
			begin
				test = eval (test.to_s)#work from symbols instead... 
			rescue NameError => e
				puts e.message
			end
		end
	
		@couples ||={}
		if ((not test.is_a? Symbol) and c = @couples[test]) then
			return c
		elsif @parent then
			return @parent.couple(test)
		elsif self != Library.library
			puts "Default to library's couplings for:#{test}"
			Library.library.couple(test)
		else
			raise("#{self} don't have anything to couple to #{test}")
		end
	end
	def __parent; @parent; end
	
		#remove the last one
	def couplex(test,_klass,&block)
		klass = ClassCoupler.new(_klass,self,&block)
		#puts klass.inspect
		@couples ||={}
		@couples[test] = klass
		puts "couple  test:#{test.name} -> #{_klass} on #{self}"
	#	klass.instance_eval &block if block
		#remove the last one
		self
	end
end

#	def couple(test)
#		Kernel.couple(test)
#	end

