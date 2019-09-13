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
end
