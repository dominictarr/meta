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
	if other.__wrapped__ then
		other.equal? self
	else
		self.__equal?(other)
	end
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
		def initialize (wrap,parent,&block)
			puts "#INITIALIZE!"
	   	@wrapped = wrap
	   	@parent = parent 
	   	__instance_eval__ &block if block
	   end
		def method_missing(m_name, *args, &block)
			puts "CALL:#{m_name}"
			@wrapped.method(m_name).call(*args, &block)
		end
	end
	def couple(test)
		@couples ||={}
		if c = @couples[test] then
			return c
		elsif @parent then
			return @parent.couple(test)
		elsif self != Library.library
			Library.library.couple(test)
		else
			raise("#{self} don't have anything to couple to #{test}")
		end
	end
	def __parent; @parent; end
	
		#remove the last one
	def couplex(test,klass,&block)
		klass = ClassCoupler.new(klass,self,&block)
		puts klass.inspect
		@couples ||={}
		@couples[test] = klass
	#	klass.instance_eval &block if block
		#remove the last one
		self
	end
end
