module QuickAttr
#QUICK_ATTR_NIL = "QUICK_ATTR_NIL".freeze
def quick_attr (*args)
	args.each {|var|
		ivar = "@#{var}"
#	send :define_method, var, proc {|arg|
#		return send (:instance_variable_get, ivar) if arg.nil? 
#		send (:instance_variable_set, ivar, arg)
#		self
#		}
	class_eval "def #{var} (*arg,&block)
		raise \"cannot call #{var} with block and (#{args.join(',')}\" if arg.length > 0 and block
		arg[0] = block if block
		return #{ivar} if arg.length == 0
		#{ivar} = arg[0] if arg.length == 1
		#{ivar} = arg if arg.length > 1
		self
	end"
	
	#class_eval "def #{var} (arg=(QUICK_ATTR_NIL = \"\"))
	#	return #{ivar} if arg.object_id == QUICK_ATTR_NIL.object_id
	#	#{ivar} = arg
	#	self
	#end"
	}
end

def quick_array (*args)
	klass = Array
	if args.first.is_a? Class then
	 klass = args.shift 
	end
	args.each {|var|
		ivar = "@#{var}"
	class_eval "def #{var} (*arg)
	 	if arg.length == 0 then
			return #{ivar} = #{ivar} || #{klass.name}.new
		else
			#{ivar} = arg.is_a?(#{klass}) ? arg : #{klass}.new(arg)
			self
		end
	end"
		
	}
end
end


