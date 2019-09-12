=begin
       	CSC 253/453 Project 1b: Itertors in Ruby
=end

module P1
   	def p1_all?(pattern = nil) #1
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
   
   	def p1_chunk #2
 		result = inject [] do |acc, e|
			return acc if !block_given? or yield(e).nil?
			if acc.empty? or acc.last[0] != yield(e)
				acc << [yield(e), [e]]
			else
				(acc[-1][1] << e) && acc
			end
		end
		result.to_enum
   	end
   
   	def p1_slice_after(*args) #10
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
		result = inject [] do |acc, e|
			if acc.empty? or match[acc.last.last]
                                acc << [e]
                        else
                                (acc[-1] << e) && acc
                        end
                end
		result.to_enum
   	end
end
