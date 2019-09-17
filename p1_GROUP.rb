=begin
	CSC 253/453 Project 1b: Iterators in Ruby
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
		result = p1_inject [[]] do |acc, e|
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

	def p1_max(n = nil)
		match = lambda do |x, y|
                        block_given?? yield(x, y): x <=> y
                end
		result = p1_inject (n.nil?? []: {0 => []}) do |res, e|
			if res.is_a? Array
				res[0] = e if res.empty? or match[res[0], e] < 0
			else
				n.times do |i|
					if res[0][i].nil?
						res[0][i] = e
						break
					elsif match[res[0][i], e] < 0
						res[0][i], e = e, res[0][i]
					end
				end
			end
                        res
                end
                result[0]
	end

	def p1_minmax
		match = lambda do |x, y|
                        block_given?? yield(x, y): x <=> y
                end
		result = p1_inject [nil, nil] do |res, e|
			res[0] = e if res[0].nil? || match[res[0], e] > 0
			res[1] = e if res[1].nil? || match[res[1], e] < 0
			res
                end
		result
	end

	def p1_zip(*args, &block)
		# Check whether all args are enumerable
		args.each do |arr|
			if !arr.respond_to? :each
				raise TypeError, "wrong argument type #{arr.class} (must respond to :each)"
			end
		end

		block_args = []
		args.p1_each_with_index do |arg, i|
			index = 0
			arg.each do |elem|
				block_args[index].nil?? block_args[index] = [nil] * i + [elem]: block_args[index] << elem
				index += 1
			end

                end
		index = 0
		ret = []
                each do |elem|
			entry = [elem, *block_args[index]]
			entry += [nil] * (args.length + 1 - entry.length)
			if block_given?
				yield(*entry)
			else
				ret << entry
			end
			index += 1
                end
                block_given?? nil: ret
	end

	def p1_each_with_index(*args)
		index = 0
                if block_given?
                        each(*args) do |elem|
                                yield(elem, index)
                                index += 1
                        end
                        return self
                else
                        result = []
                        each do |elem|
                                result << [elem, index]
                                index += 1
                        end
                        return result.to_enum
                end
	end

	def p1_collect
		return p1_inject([]){|a,b| a.push(yield b)} if block_given?
		return self.to_enum
	end

	def p1_select
		return p1_inject([]){|a,b| (yield b) ? a.push(b) : a } if block_given?
		return self.to_enum
	end
end
