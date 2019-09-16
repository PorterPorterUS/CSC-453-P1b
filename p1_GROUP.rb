=begin
       	CSC 253/453 Project 1b: Itertors in Ruby
	September 17 2019
=end

module P1
	def p1_inject(*args)
		if args.length == 2
			raise TypeError, "#{args[1]} is not a symbol nor a string" unless [String, Symbol].member? args[1].class
			accumulator = args[0]
			operation = -> x, y { x.send(args[1], y) }
		elsif args.length == 1
			if block_given?
				accumulator = args[0]
				operation = -> x, y { yield(x, y) }
			else
				raise TypeError, "#{args[0]} is not a symbol nor a string" unless [String, Symbol].member? args[0].class
				accumulator == nil
				operation = -> x, y { x.send(args[0], y) }
			end
		elsif args.length == 0
                        accumulator = nil
			operation = -> x, y { yield(x, y) }
		else
			raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0..2)"
		end

		if accumulator.nil?
			ignore_first = true
			accumulator = first
		end

		is_first = true
		self.each do |element|
			unless is_first && ignore_first
				accumulator = operation[accumulator, element]
			end
			is_first = false
		end
		accumulator
	end

	def p1_find(ifnone = nil)
		result = nil
		found = false
		if block_given?
			self.each do |element|
				if yield element
					result = element
					found = true
					break
				end
			end
			found ? result : ifnone && ifnone.call
		else
			return self.to_enum
		end
	end

	def p1_all?(pattern = nil)
		match = lambda do |e|
			if !pattern.nil?
				pattern === e
			elsif block_given?
				yield(e)
			else
				true
			end
		end
		each do |element|
			return false unless !element.nil? && match[element]
                end
      		true
   	end
   
	def p1_chunk
 		result = inject [] do |acc, e|
			if !block_given? or yield(e).nil?
				acc
			elsif acc.empty? or acc.last[0] != yield(e)
				acc << [yield(e), [e]]
			else
				(acc[-1][1] << e) && acc
			end
		end
		result.to_enum
   	end

	def p1_slice_after(*args)
		if block_given?
			raise ArgumentError.new("both pattern and block are given") if args.length > 0
		else
			raise ArgumentError.new("wrong number of arguments (given #{args.length}, expected 1)") if args.length != 1
		end

		match = lambda do |e|
			if args.length == 1
				args[0] === e	
                        elsif block_given?
                                yield(e)
                        end
                end			
		result = inject [[]] do |acc, e|
			if !match[e]
                                (acc[-1] << e) && acc
			else
				acc[-1] << e
				(acc << []) && acc
                        end
                end
		result.pop if result[-1] == []
		result.to_enum
   	end

	def p1_max(*args,&block)
		if self.size==0
			if args.size==0
				return nil
			else
				return self
			end
		end

		if args.size==0 && block.nil?
			max_item=self[0]
			self.drop(1).each do |item|
				max_item = (max_item>item)? max_item:item
			end
			return max_item
		elsif args.size==0
			max_item=self[0]
			self.drop(1).each do |item|
				p yield(max_item,item)
				max_item = yield(max_item,item)>0? max_item:item
			end
			return max_item
		else
			if args[0]==0
				return self.clone.clear
			end
			res=Array.new
			idx=(0...self.length).to_a
			idx_exist=[]
			num=args[0]
			while num>0 and res.size!=self.size
				max_idx=(idx-idx_exist)[0]
				max_item=self[max_idx]
				(idx-idx_exist-[max_idx]).each do |i|
					if block.nil? && max_item<self[i]
						max_item=self[i]
						max_idx=i
					elsif !block.nil? && yield(max_item,self[i])==-1
						max_item=self[i]
						max_idx=i
					end
				end
				res<<max_item
				idx_exist<<max_idx
				num-=1
			end

			return res
		end

	end

	def p1_minmax(*args, &block)
		if self.size==0
			return [nil,nil]
		end

		min_item=self[0]
		max_item=self[0]
		self.drop(1).each do |item|
			if block.nil?
				if max_item<item
					max_item=item
				end
				if min_item>item
					min_item=item
				end
			else
				if yield(max_item,item)==-1
					max_item=item
				end
				if yield(min_item,item)==1
					min_item=item
				end
			end
		end

		return [min_item,max_item]
	end

	def p1_zip(*args, &block)
		# Check whether all args are enumerable
		args.each do |arr|
			if !arr.respond_to? :each
				raise TypeError, "wrong argument type #{arr.class} (must respond to :each)"
			end
		end

		ret = []
		# TODO: change to p1_each_with_index
		self.each_with_index do |item, index|
			tmp = [item]
			args.each do |arr|
				tmp << ((index >= arr.length) ? nil : arr[index])
			end
			ret << tmp
		end
		if block_given?
			#TODO: change to p1_collect
			ret.collect {|elem| yield(*elem)}
			return nil
		end
		return ret
	end

	def p1_each_with_index(*args)
		index = 0
		each(*args) do |elem|
			yield(elem, index)
			index += 1
		end
		self
	end
end
