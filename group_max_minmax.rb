#!/usr/bin/ruby

module P1
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

class Object
  include P1
end