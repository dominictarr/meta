

class Diff
extend QuickAttr
	quick_attr :split, :join
	
	def initialize
		split ""
	end
	
	def arrayize (string)
		if string.is_a? Array
			string
		elsif string.is_a? String
			string.split(split)
		else
			raise "Diff works on only Strings or Array. not #{string} (#{string.class})"
		end
	end
	def same (x,y)
	s = []
		for i in 0..(x.length - 1) do
			return s if x[i] != y[i]
			s << x[i]
		end
			s
	end
	def delete(x,y)
		insert(y,x)
	end
	def insert (x,y)
		pass = []
		targ = y.first
		x.each{|e|
			return pass if e == targ
			pass << e
		}	
	end
	
	def chomp (lookfor,b,i)
		passed = []
		j = 0
		for j in i..(b.length - 1) do
		
			if lookfor == b[j] then
				true 
			else 
				passed << f
				false
			end
		end
		return passed, j
	end
	
	def diff(_x,_y)
	d = []
	 
	 x = arrayize(_x)
	 y = arrayize(_y)
	 
	 	for i in 0..(x.length - 1) do
		#match, j = chomp(lookfor,y,i)

		#if i == j then
		#d << x[i]
		#else
			
		end	 	
	#		if x[i] == y[i] then
	#			d << x[i]
	#		else
	#		a = []
	#		b = []
	#		a << x[i] 
	#		b << y[i] 
	#		d << [a,b]			

	 end
end

p
