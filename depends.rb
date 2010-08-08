require 'set'
class Depends

	def depends
		@dep ||={}
	end
	def depends_on(klass,*requires)
		@dep ||={}
		@dep[klass] ||=Set.new
		@dep[klass].merge(requires)
		puts @dep[klass].inspect
	end
	def requires(klass)
		@dep[klass].each{|r|
			require r		
		} if @dep[klass]
		eval klass.to_s
	end
end
