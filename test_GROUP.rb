require_relative "p1_GROUP"

require 'minitest/autorun'

class Object
  include P1
end

# DARYL_BAGLEY
TestResult = Struct.new(:actual, :expected)

module InjectTests
  def Inject_Nil
    return TestResult.new([].p1_inject{|a,b| a + b}, nil)
  end

  def Inject_Singleton
    return TestResult.new([14].p1_inject{|a,b| a + b}, 14)
  end

  def Inject_Summation
    return TestResult.new([0,1,0,1,0,1,1,0].p1_inject{|a,b| a + b}, 4)
  end

  def Inject_And
    return TestResult.new([0,1,0,1,0,1,1,0].p1_inject{|a,b| a && b}, 0)
  end

  def Inject_Complex_Function
    return TestResult.new(['I',"don't","know","what","words","to","use"].p1_inject([]){|a,b| a.push(b.chars.sort.p1_inject{|x,y|x+y})}, ["I", "'dnot", "know", "ahtw", "dorsw", "ot", "esu"])
  end

  def Inject_Char_Function
    return TestResult.new("Inject_Complex_Function".chars.sort.p1_inject{|x,y|x+y}, "CFI__cceeijlmnnnoopttux")
  end

  def Inject_Error_No_Args
    result = TestResult.new("","no error was raised")
    begin
      ["Hi"].p1_inject
    rescue ArgumentError
      result.actual = "an error was raised"
    else
      result.actual = "no error was raised"
    end
    return result
  end
  def Inject_Error_Bad_Args
    result = TestResult.new("","an error was raised")
    begin
      ["Hi"].p1_inject(2014)
    rescue TypeError
      result.actual = "an error was raised"
    else
      result.actual = "no error was raised"
    end
    return result
  end
end

module CollectTests
  def Collect_Double
    return TestResult.new([1,2,3,4].p1_collect{ |i| i*2 },[2,4,6,8])
  end

  def Collect_Singleton
    return TestResult.new([20].p1_collect{ |i| i.to_s },["20"])
  end

  def Collect_Nil
    return TestResult.new([].p1_collect{ |i| i.to_s },[])
  end
end

module AllTests
  def All_No_Args
    return TestResult.new([1,2,3,4].p1_all?,true)
  end

  def All_Pattern
    return TestResult.new(["INTJ","INTP","ENTJ","ENTP"].p1_all?(/NT/),true)
  end

  def All_Block
    return TestResult.new([5,-1,1,1,1,1,1,1].p1_all?{ |i| i > 0 },false)
  end

  def All_Singleton
    return TestResult.new([2014].p1_all?{ |i| i%2 == 1 },false)
  end

  def All_Nil
    return TestResult.new([].p1_all?{ |i| i.class == Object },true)
  end
end

module FindTests
  def Find_Nil
    return TestResult.new([].p1_find{ |i| i.class == Object },nil)
  end

  def Find_Singleton_Success
    return TestResult.new([2014].p1_find{ |i| i%2 == 0 },2014)
  end

  def Find_Singleton_Fail
    return TestResult.new([2014].p1_find{ |i| i%2 == 1 },nil)
  end
=begin
  def Find_If_None
    return TestResult.new(["Yolo","Swag"].p1_find(:none){ |i| i.class == Symbol }, :none)
  end
=end

  def Find_Goose
    return TestResult.new(["Duck","Duck","Duck","Goose","Duck","Goosed","Duck","Goose, Duck"].p1_find(){ |i| /Goose/ === i }, "Goose")
  end

end

module MinmaxTests
  def Minmax_Nil
    return TestResult.new([].p1_minmax, [nil,nil])
  end

  def Minmax_Singleton
    return TestResult.new([7].p1_minmax, [7,7])
  end

  def Minmax_Singleton_Almost
    return TestResult.new(["Hello", "Hello"].p1_minmax, ["Hello", "Hello"])
  end

  def Minmax_Integers
    return TestResult.new([1,2,3,-1,0,14,-1,0,3,2,1].p1_minmax, [-1,14])
  end

  def Minmax_Strings
    return TestResult.new(["daryl","alpha","was","net","beta",'here'].p1_minmax, ["alpha","was"])
  end

  def Minmax_Block
    return TestResult.new(['014','21','17','10'].p1_minmax{ |a,b| a.to_i <=> b.to_i }, ["10","21"])
  end
end

module SelectTests
  def Select_Nil
    return TestResult.new([].p1_select{|a| !a.nil?}, [])
  end

  def Select_Singleton
    return TestResult.new([14].p1_select{|a| !a.nil?}, [14])
  end

  def Select_Remove_Nil
    return TestResult.new([String,nil,"14",nil,nil,23,true,nil,Object,[],nil,false,"not false"].p1_select{|a| !a.nil?}, [String,"14",23,true,Object,[],false,"not false"])
  end

  def Select_Integers
    return TestResult.new([5,10,15,20,25,30,35,40].p1_select{|a| a.even?}, [10,20,30,40])
  end
end

module EachWithIndexTests
  def EachWithIndex_Nil
    result = TestResult.new("","no error was raised")
    begin
      [].p1_each_with_index{|a,i| [a]*i}
    rescue
      result.actual = "an error was raised"
    else
      result.actual = "no error was raised"
    end
    return result
  end

  def EachWithIndex_Singleton
    result = TestResult.new([],[5])
    [5].p1_each_with_index{|a,i| result.actual+=[a]*(i+1)}
    return result
  end

  def EachWithIndex_Messy
    result = TestResult.new([],[99,"bottles","bottles",nil,nil,nil,:the_wall,:the_wall,:the_wall,:the_wall])
    [99,"bottles",nil,:the_wall].p1_each_with_index{|a,i| result.actual+=[a]*(i+1)}
    return result
  end
end

module MaxTests
  def Max_Nil
    return TestResult.new([].p1_max, nil)
  end

  def Max_Singleton
    return TestResult.new([7].p1_max, 7)
  end

  def Max_Singleton_Almost
    return TestResult.new(["Hello", "Hello"].p1_max, "Hello")
  end

  def Max_Integers
    return TestResult.new([1,2,3,-1,0,14,-1,0,3,2,1].p1_max, 14)
  end

  def Max_Integers_Set
    return TestResult.new([1,2,3,-1,0,14,-1,0,3,2,1].p1_max(5), [14,3,3,2,2])
  end

  def Max_Strings
    return TestResult.new(["daryl","alpha","was","net","beta",'here'].p1_max, "was")
  end

  def Max_Strings_Set
    return TestResult.new(["daryl","alpha","was","net","beta",'here'].p1_max(3), ["was", "net", "here"])
  end

  def Max_Block
    return TestResult.new(['014','21','17','10'].p1_max{ |a,b| a.to_i <=> b.to_i }, "21")
  end

  def Max_Block_Set
    return TestResult.new(['014','21','17','10'].p1_max(2){ |a,b| a.to_i <=> b.to_i }, ["21", "17"])
  end
end

module ZipTests
  def Zip_Nil
    return TestResult.new([].p1_zip([5]), [])
  end

  def Zip_Niller
    return TestResult.new([].p1_zip([]), [])
  end

  def Zip_Nillest
    return TestResult.new(["lol","ol","ol"].p1_zip([]), [["lol",nil],["ol",nil],["ol",nil]])
  end

  def Zip_School_Years
    return TestResult.new([2010,2014].p1_zip([2014,2018],["High School","Undergrad"]), [[2010, 2014, "High School"], [2014, 2018, "Undergrad"]])
  end

  def Zip_Many_Params
    return TestResult.new([:a,:b,:c,:d].p1_zip(['a','b','c','d'],["A","B","C","D"],[1,2,3,4],['!','@','#','$'],["|","||","|||","||||"]), [[:a, "a", "A", 1, "!", "|"], [:b, "b", "B", 2, "@", "||"], [:c, "c", "C", 3, "#", "|||"], [:d, "d", "D", 4, "$", "||||"]])
  end
end

module ChunkTests
  def Chunk_Nil
	  return TestResult.new([].p1_chunk{|a| a}.to_a, [])
  end

  def Chunk_Singleton
	  return TestResult.new([14].p1_chunk{|a| a}.to_a, [[14,[14]]])
  end

  def Chunk_First_Letter
	  return TestResult.new("hello and welcome to the best day of your life".split.sort.p1_chunk{|a| a.ord.chr}.to_a, [["a", ["and"]], ["b", ["best"]], ["d", ["day"]], ["h", ["hello"]], ["l", ["life"]], ["o", ["of"]], ["t", ["the", "to"]], ["w", ["welcome"]], ["y", ["your"]]])
  end
end

module SliceAfterTests
  def SliceAfter_Nil
	  return TestResult.new([].p1_slice_after{|a| a}.to_a, [])
  end

  def SliceAfter_Singleton
	  return TestResult.new([14].p1_slice_after{|a| a}.to_a, [[14]])
  end

  def SliceAfter_Even_Year
	  return TestResult.new([2013,2015,2016,2017,2018,2020].p1_slice_after{|a| a % 2 == 0}.to_a, [[2013, 2015, 2016], [2017, 2018], [2020]])
  end

  def SliceAfter_Long_Word
	  return TestResult.new("hello and welcome to one more truly worthwhile day".split.p1_slice_after(/...../).to_a, [["hello"], ["and", "welcome"], ["to", "one", "more", "truly"], ["worthwhile"], ["day"]])
  end
end

class P1_Test
  def self.testSets
	  return [AllTests, ChunkTests, SliceAfterTests, MinmaxTests, MaxTests, InjectTests, FindTests
=begin
	CollectTests, SelectTests, EachWithIndexTests, ZipTests		  
	  
=end
]

  end

  testSets.each{ |testSet| extend testSet }

  def self.run
    Array.include(P1)

    (testSets.map { |e| e.instance_methods(false) }.inject([]){ |acc, elem| acc + elem } + methods(false).select{|m| m != :run && m != :testSets}).sort.each do |m|
      result = send(m)
      puts m.to_s + (result.actual == result.expected ? ": PASSED" : ": *FAILED*") +
           (result.actual == result.expected ? "" : "\n - Result was #{result.actual} but should have been #{result.expected}")
    end

  end

end

P1_Test.run

# SHUANG_ZHAI

class TestP1 <  Minitest::Test


  def test_p1_inject_with_block
    res1 = (5..10).p1_inject { |sum, n| sum + n }
    res2 = (5..10).inject { |sum, n| sum + n }
    assert_equal res1, res2
  end

  def test_p1_inject_with_block_and_initial
    res1 = (5..10).p1_inject(0) { |sum, n| sum + n }
    res2 = (5..10).inject(0) { |sum, n| sum + n }
    assert_equal res1, res2
  end

  def test_p1_inject_with_inital_and_sym
    res1 = (5..10).p1_inject(1, :*) 
    res2 = (5..10).inject(1, :*)
    assert_equal res1, res2
  end

  def test_p1_inject_with_sym
    res1 = (5..10).p1_inject(:+) 
    res2 = (5..10).inject(:+)
    assert_equal res1, res2
  end

=begin
  def test_p1_collect
    res1 = (1..4).collect { |i| i*i }
    res2 = (1..4).p1_collect { |i| i*i }
    assert_equal res1, res2
  end

  def test_p1_each_with_index
    hash1 = Hash.new
    hash2 = Hash.new
    
    %w(cat dog wombat).each_with_index { |item, index|
      hash1[item] = index
    }
    %w(cat dog wombat).p1_each_with_index { |item, index|
      hash2[item] = index
    }
    
    assert_equal hash1, hash2
  end

  def test_p1_select1
    res1 = (1..10).select { |i|  i % 3 == 0 }
    res2 = (1..10).p1_select { |i|  i % 3 == 0 }
    assert_equal res1, res2
  end

  def test_p1_select2
    res1 = [1,2,3,4,5].select { |num|  num.even?  }
    res2 = [1,2,3,4,5].p1_select { |num|  num.even?  }
    assert_equal res1, res2
  end

  def test_p1_select3
    res1 = [:foo, :bar].select { |x| x == :foo }
    res2 = [:foo, :bar].p1_select { |x| x == :foo }
    assert_equal res1, res2
  end
=end

  def test_p1_max
    a = %w(albatross dog horse)
    res1 = a.max
    res2 = a.p1_max
    assert_equal res1, res2
  end

  def test_p1_max2
    a = %w(albatross dog horse)
    res1 = a.max { |a, b| a.length <=> b.length }
    res2 = a.p1_max { |a, b| a.length <=> b.length }
    assert_equal res1, res2
  end

  def test_p1_max3
    a = %w(albatross dog horse)
    res1 = a.max(2) {|a, b| a.length <=> b.length }
    res2 = a.p1_max(2) { |a, b| a.length <=> b.length }
    assert_equal res1, res2
  end

  def test_p1_max4
    a = %w(albatross dog horse)
    res1 = a.max(2)
    res2 = a.p1_max(2)
    assert_equal res1, res2
  end

  def test_p1_max4
    a = [123, 4124, 51, 5124]
    res1 = a.max(2)
    res2 = a.p1_max(2)
    assert_equal res1, res2
  end

  def test_p1_max5
    res1 = [5, 1, 3, 4, 2].max(3)
    res2 = [5, 1, 3, 4, 2].p1_max(3)
    assert_equal res1, res2
  end
  
  def test_p1_chunk
    res1 = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5].p1_chunk { |n|
      n.even?
    }.to_a
    res2 = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5].chunk { |n|
      n.even?
    }.to_a
    assert_equal res1, res2
  end

  def test_p1_all
    res1 = %w[ant bear cat].all? { |word| word.length >= 3 }
    res2 = %w[ant bear cat].p1_all? { |word| word.length >= 3 }
    assert_equal res1, res2
  end

  def test_p1_all2
    res1 = %w[ant bear cat].all? { |word| word.length >= 4 }
    res2 = %w[ant bear cat].p1_all? { |word| word.length >= 4 }
    assert_equal res1, res2
  end

  def test_p1_all3
    res1 = %w[ant bear cat].all?(/t/)
    res2 = %w[ant bear cat].p1_all?(/t/)
    assert_equal res1, res2
  end

  def test_p1_all4
    res1 = [1, 2i, 3.14].all?(Numeric)
    res2 = [1, 2i, 3.14].p1_all?(Numeric)
    assert_equal res1, res2
  end

  def test_p1_all5
    res1 = [nil, true, 99].all?
    res2 = [nil, true, 99].p1_all? 
    assert_equal res1, res2
  end

  def test_p1_all6
    res1 = [].all?
    res2 = [].p1_all? 
    assert_equal res1, res2
  end
=begin
  def test_p1_zip1
    a = [ 4, 5, 6 ]
    b = [ 7, 8, 9 ]
    res1 = a.zip(b)
    res2 = a.p1_zip(b)
    assert_equal res1, res2
  end

  def test_p1_zip2
    a = [ 4, 5, 6 ]
    b = [ 7, 8, 9 ]
    res1 = [1, 2, 3].zip(a, b)
    res2 = [1, 2, 3].p1_zip(a, b)
    assert_equal res1, res2
  end

  def test_p1_zip3
    a = [ 4, 5, 6 ]
    b = [ 7, 8, 9 ]
    res1 = [1, 2].zip(a, b) 
    res2 = [1, 2].p1_zip(a, b) 
    assert_equal res1, res2
  end

  def test_p1_zip4
    a = [ 4, 5, 6 ]
    b = [ 7, 8, 9 ]
    res1 = a.zip([1, 2], [8]) 
    res2 = a.p1_zip([1, 2], [8]) 
    assert_equal res1, res2
  end

  def test_p1_zip5
    a = [ 4, 5, 6 ]
    b = [ 7, 8, 9 ]
    c1 = []
    c2 = []
    a.zip(b) { |x, y| c1 << x + y }
    a.zip(b) { |x, y| c2 << x + y }
    assert_equal c1, c2
  end
=end
  def test_p1_find
    res1 = (1..10).find   { |i| i % 5 == 0 and i % 7 == 0 }
    res2 = (1..10).p1_find   { |i| i % 5 == 0 and i % 7 == 0 }
    assert_equal res1, res2
  end

  def test_p1_find2
    res1 = (1..100).find    { |i| i % 5 == 0 and i % 7 == 0 }
    res2 = (1..100).p1_find    { |i| i % 5 == 0 and i % 7 == 0 }
    assert_equal res1, res2
  end

  def test_p1_find3
    res1 = (1..10).find(lambda {1+1})   { |i| i % 5 == 0 and i % 7 == 0 }
    res2 = (1..10).p1_find(lambda {1+1})   { |i| i % 5 == 0 and i % 7 == 0 }
    assert_equal res1, res2
  end

  def test_p1_minmax
    a = %w(albatross dog horse)
    res1 = a.minmax
    res2 = a.p1_minmax
    assert_equal(res1, res2)
  end

  def test_p1_minmax2
    a = %w(albatross dog horse)
    res1 = a.minmax { |a, b| a.length <=> b.length }
    res2 = a.p1_minmax { |a, b| a.length <=> b.length }
    assert_equal res1, res2
  end

  def test_p1_minmax3
    a = [123, 415, 245, 414, 532]
    res1 = a.minmax
    res2 = a.p1_minmax
    assert_equal(res1, res2)
  end

  def test_p1_slice_after
    lines = ["foo\n", "bar\\\n", "baz\n", "\n", "qux\n"]
    res1 = lines.slice_after(/(?<!\\)\n\z/).to_a
    res2 = lines.p1_slice_after(/(?<!\\)\n\z/).to_a
    assert_equal res1, res2
  end
end

# SOUBHIK_GHOSH

describe "Array: P1" do

	describe "inject " do
		it "Sum all numbers with initial" do
                 	result = [1, 2, 3, 4].p1_inject 5 do |sum, e|
                        	sum + e
			end
			expected_result = [1, 2, 3, 4].inject 5 do |sum, e|
                                sum + e
                        end
			result.must_equal expected_result
		end

		it "Sum all numbers with symbol" do
			result = [1, 2, 3, 4].p1_inject :+
			result.must_equal 10
		end

		it "Multiply numbers using initial and symbol" do
			result = [1, 2, 3, 4].p1_inject 5, :*
			result.must_equal 120
		end

		it "Multiply all numbers with no initial" do
                        result = [1, 2, 3, 4].p1_inject do |product, e|
                                product * e
			end
			result.must_equal 24
                end

		it "Return the longest word" do 
			result = %w{cat sheep bear}.p1_inject do |memo, word|
				memo.length > word.length ? memo : word
			end
			result.must_equal "sheep"
		end

		it "Return initial for empty array" do
                        result = [].p1_inject 5 do |sum, e|
                                sum + e
                        end
                        result.must_equal 5
                end

		it "Return nil for empty input array" do
                        result = [].p1_inject {}
                        result.must_be_nil
                end
	end

=begin
	describe "collect " do
		before do
			@input_arr = [1, 2, 3, 4]
		end

                it "Square all numbers" do
                        result_arr = @input_arr.p1_collect do |i| 
				i * i 
			end
			result_arr.must_equal [1, 4, 9, 16]
			result_arr.object_id.wont_equal @input_arr.object_id
                end

		it "Replace all numbers with cat" do
                        result_arr = @input_arr.p1_collect do 
				"cat"
			end
                        result_arr.must_equal ["cat"] * 4
			result_arr.object_id.wont_equal @input_arr.object_id
                end

		it "Return empty array for empty input" do
                        result_arr = [].p1_collect {}
			result_arr.must_equal []
                end
        end
=end
	describe "all? " do
		it "Return true when all words are longer than 2 characters" do
			result = %w[ant bear cat].p1_all? do |word| 
				word.length >= 3
			end
                        result.must_equal true
                end

		it "Return false when some words are shorter than 4 characters" do
                        result = %w[ant bear cat].p1_all? do |word|
                                word.length >= 4
                        end
                        result.must_equal false
                end

		it "Return false when some words don't have the letter 't'" do
                        result = %w[ant bear cat].p1_all? /t/
                        result.must_equal false
                end

		it "Return true for all Numeric values" do
                        result = [1, 2i, 3.14].p1_all? Numeric
                        result.must_equal true
                end

		it "Return true for empty input" do
                        result = [].p1_all? {}
                        result.must_equal true
			result = [].p1_all?
                        result.must_equal true
                end
	end

	describe "chunk " do
                it "Chunk even and odd numbers" do
                        result = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5].p1_chunk do |n|
				n.even?
			end.to_a
			result[0].must_equal [false, [3, 1]]
			result[1].must_equal [true, [4]]
			result[2].must_equal [false, [1, 5, 9]]
			result[3].must_equal [true, [2, 6]]
			result[4].must_equal [false, [5, 3, 5]]
                end

		it "Chunk words based on their length" do
                        result = %w[cat dog wombat skunk koala].p1_chunk do |item|
				item.length
			end.to_a
                        result[0].must_equal [3, ["cat", "dog"]]
                        result[1].must_equal [6, ["wombat"]]
                        result[2].must_equal [5, ["skunk", "koala"]]
                end

		it "Return empty array for no input block" do
			result = [2, 4].p1_chunk.to_a
                        result.must_equal []
                end

		it "Return empty array for empty input" do
			result = [].p1_chunk {}.to_a
			result.must_equal []
                end
        end
=begin
	describe "each_with_index " do
                it "Create hash values from the indices" do
			input_array = %w[cat dog wombat]
			hash = Hash.new
			result_arr = input_array.p1_each_with_index do |item, index|
  				hash[item] = index
			end
			hash.must_equal Hash["cat"=>0, "dog"=>1, "wombat"=>2]
			result_arr.must_equal %w[cat dog wombat]
			result_arr.object_id.must_equal input_array.object_id
                end

		it "Create correct output from the indices" do
			input_array = [5, 6, 7, 8]
			output = []
			result_arr = input_array.p1_each_with_index do |item, index|
				output << index * item
                        end
                        output.must_equal [0, 6, 14, 24]
			result_arr.must_equal [5, 6, 7, 8]
			result_arr.object_id.must_equal input_array.object_id
                end

		it "Skip block for empty input array" do
                        is_called = false
                        result_arr = [].p1_each_with_index do |item, index|
                                is_called = true
                        end
			result_arr.must_equal []
			is_called.must_equal false
                end
        end
=end
	describe "find " do
                it "Won't find an element and return nil" do
			result = [*(2..10)].p1_find { |i| i % 5 == 0 and i % 7 == 0 } 	
                        result.must_be_nil
                end
		
		it "Find an element and return the element" do
                        result = [*(2..100)].p1_find { |i| i % 5 == 0 and i % 7 == 0 }
                        result.must_equal 35
                end

		it "Nothing find in empty array and return nil" do
                        result = [].p1_find {}
                        result.must_be_nil
                end

		it "Won't find an element and call ifnone" do
                        result = [*(2..10)].p1_find(proc {20}) { |i| i % 5 == 0 and i % 7 == 0 }
                        result.must_equal 20
                end
        end


	describe "max " do
		it "Return the max result as it is" do
                        result = %w[albatross dog horse].p1_max do |a, b| 
                                a.length <=> b.length
                        end
                        result.must_equal "albatross"
                end

		it "Return the max result in an array" do
                        result_arr = %w[albatross dog horse].p1_max 1 do |a, b|
                                a.length <=> b.length
                        end
                        result_arr.must_equal ["albatross"]
		end

		it "Return the max result without a block input" do
                        result = %w[albatross dog horse].p1_max
                        result.must_equal "horse"
                end

		it "Return the maximum 2 elements" do
                        result_arr = %w[albatross dog horse].p1_max 2 do |a, b|
                                a.length <=> b.length
                        end
                        result_arr.must_equal ["albatross", "horse"]
                end

		it "Return the maximum 2 elements without a block input" do
                        result_arr = %w[albatross dog horse].p1_max 2
                        result_arr.must_equal ["horse", "dog"]
                end

		it "Return all elements in descending order" do
                        result_arr = %w[albatross dog horse].p1_max 4 do |a, b|
                                a.length <=> b.length
                        end
                        result_arr.must_equal ["albatross", "horse", "dog"]
                end

		it "Return empty array or nil for empty input" do
                        result_arr = [].p1_max(1) {}
                        result_arr.must_equal []

			result = [].p1_max {}
                        result.must_be_nil
                end

	end

	describe "minmax " do
                it "Find min max words" do
                        result = %w[albatross dog horse].p1_minmax do |a, b| 
				a.length <=> b.length
			end
			result.must_equal ["dog", "albatross"]
		end

		it "Find min max words without a block" do
                        result = %w[albatross dog horse].p1_minmax
                        result.must_equal ["albatross", "horse"]
                end

		it "Find min max numbers" do
                        result = [3, 5, 7].p1_minmax do |a, b|
                                a <=> b
                        end
                        result.must_equal [3, 7]
                end

		it "Return [nil, nil] for empty input" do
                        result = [].p1_minmax {}
                        result.must_equal [nil, nil]
			result = [].p1_minmax
                        result.must_equal [nil, nil]
                end

		it "Return value as both min and max for array with 1 element" do
                        result = [4].p1_minmax do |a, b|
                                a <=> b
                        end
                        result.must_equal [4, 4]
                end

	end
=begin
	describe "select " do
                it "Select all the even numbers" do
                        result = [1, 2, 3, 4, 5].p1_select do |num|
                                num.even?
                        end
                        result.must_equal [2, 4]
                end

		it "Select all multiples of 15" do
			result = [*(1...100)].p1_select do |num|
                                num % 3 == 0 and num % 5 == 0
                        end
                        result.must_equal [15, 30, 45, 60, 75, 90]
                end

		it "Won't select even from a list of odd numbers" do
                        result = [1, 3, 5, 7].p1_select do |num|
                                num.even?
                        end
			result.must_equal []
                end

		it "Won't select for empty input" do
                        result = [].p1_select {}
                        result.must_equal []
                end	
        end


	describe "zip " do
                it "Add up values from 2 arrays" do
			c = []
                        result = [4, 5, 6].p1_zip [7, 8, 9] do |x, y|
                                c << x + y
                        end
                        c.must_equal [11, 13, 15]
			result.must_be_nil
                end

		it "Add up values from 3 arrays" do
                        c = []
                        result = [4, 5, 6].p1_zip [7, 8, 9], [1, 2 ,3] do |x, y, z|
                                c << x + y + z
                        end
                        c.must_equal [12, 15, 18]
			result.must_be_nil
                end

		it "Add up values for 2 unequal size arrays (1)" do
                        c = []
                        result = [1, 2, 3, 4].p1_zip [4, 5] do |x, y|
				c << x + (y.nil?? 0: y)
                        end
                        c.must_equal [5, 7, 3, 4]
			result.must_be_nil
                end

		it "Add up values for 2 unequal size arrays (2)" do
                        c = []
                        result = [3].p1_zip [4, 5, 6] do |x, y|
                                c << x + y
                        end
                        c.must_equal [7]
                        result.must_be_nil
                end

		it "Add up values for multiple unequal size arrays" do
                        c = []
                        result = [1, 2, 3].p1_zip [4], [5, 6, 7, 8], [9, 10], [] do |v, w, x, y, z|
				c << v + (w.nil?? 0: w) + x + (y.nil?? 0: y) + (z.nil?? 0: z)
                        end
                        c.must_equal [19, 18, 10]
                        result.must_be_nil
                end

		it "Zip up 2 arrays" do
                        result = [4, 5, 6].p1_zip [7, 8, 9]
                        result.must_equal [[4, 7], [5, 8], [6, 9]]
                end

		it "Zip up 3 arrays" do
			result = [1, 2, 3].p1_zip [4, 5, 6], [7, 8, 9]
                        result.must_equal [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
		end
		
		it "Zip up unequal size arrays" do
                        result = [4, 5, 6].p1_zip [1, 2], [8]
                        result.must_equal [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
                end

		it "Return empty array for empty input" do
                        c = []
                        result = [].p1_zip [4,5] do |x, y|
                                c << x + y
                        end
                        c.must_equal []
                        result.must_be_nil
                end
        end
=end
	describe "slice_after " do
                it "Group numbers from odd to even" do
                        result_arr = [1, 2, 3, 4, 5].p1_slice_after do |item|
				item.even?
			end.to_a
                        result_arr.must_equal [[1, 2], [3, 4], [5]]
                end

		it "Group letters without a block" do
			result_arr = ["a", "b", "c"].p1_slice_after("b").to_a
                        result_arr.must_equal [["a", "b"], ["c"]]
                end

		it "Group 2 elements based on different conditions" do
                        result_arr = [1, 2].p1_slice_after do |item|
                                item.even?
			end.to_a
                        result_arr.must_equal [[1, 2]]
			result_arr = [1, 2].p1_slice_after do |item|
                                item.odd?
			end.to_a
                        result_arr.must_equal [[1], [2]]
			result_arr = [1, 2, 3].p1_slice_after {}.to_a
                        result_arr.must_equal [[1, 2, 3]]
                end

		it "Group words ending with words with length 3" do
                        result_arr = %w[cat wombat dog].p1_slice_after do |item|
                                item.length == 3
			end.to_a
                        result_arr.must_equal [["cat"], ["wombat", "dog"]]
                end

		it "Return empty array for empty input" do
			result_arr = [].p1_slice_after {}.to_a
                        result_arr.must_equal []
                end
        end
end

# XIAOFEI_ZHOU

class TestP1 < Minitest::Test
=begin
	def test_p1_zip_1
		a = [4, 5]
		b = [4, 5]
		result = a.p1_zip([1,2], [8, 7])
		standard = b.zip([1,2], [8, 7])
		assert_equal standard, result
	end

	def test_p1_zip_2
		a = [4, 5, 6]
		b = [3, 7, 8]
		a2 = [4, 5, 6]
		b2 = [3, 7, 8]
		result = a.p1_zip(b)
		standard = a2.zip(b2)
		assert_equal standard, result
	end

	def test_p1_zip_3
		a = [4, 5, 6]
		b = [3, 7, 8]
		a2 = [4, 5, 6]
		b2 = [3, 7, 8]
		result = [1,2,3].p1_zip(a, b)
		standard = [1,2,3].zip(a2, b2)
		assert_equal standard, result
	end
=end

	def test_p1_slice_after_1
		result = ["fead", 1, "fd", 2].p1_slice_after(Numeric).to_a
		standard = ["fead", 1, "fd", 2].slice_after(Numeric).to_a
		assert_equal standard, result
	end

	def test_p1_slice_after_2
		result = [1, "fd", 2, "d", 7].p1_slice_after(Numeric).to_a
		standard = [1, "fd", 2, "d", 7].slice_after(Numeric).to_a
		assert_equal standard, result
	end

	def test_p1_slice_after_3
		result = ["fead", 1, "fd", 2, 7, "tes"].p1_slice_after(String).to_a
		standard = ["fead", 1, "fd", 2, 7, "tes"].slice_after(String).to_a
		assert_equal standard, result
	end
=begin
	def test_p1_select_1
		result = (1..10).p1_select
		standard = (1..10).select.to_a
		assert_equal standard, result
	end

	def test_p1_select_2
		result = (1..10).p1_select { |i| i % 3 == 0 }
		standard = (1..10).select { |i| i % 3 == 0 }.to_a
		assert_equal standard, result
	end

	def test_p1_select_3
		result = [1, 2 ,3 ,4 ,5].p1_select { |num| num.even? }
		standard = [1, 2 ,3 ,4 ,5].select { |num| num.even? }.to_a
		assert_equal standard, result
	end
=end
	def test_p1_minmax_1
		a = %w(dog alfdsfad horse)
		result = a.p1_minmax { |a, b| a.length <=> b.length }
		standard = a.minmax { |a, b| a.length <=> b.length }
		assert_equal standard, result
	end

	def test_p1_minmax_2
		a = %w(dog alfdsfad horse)
		result = a.p1_minmax
		standard = a.minmax
		assert_equal standard, result
	end

	def test_p1_minmax_3
		a = ["a", "ab", "cds"]
		result = a.p1_minmax { |a, b| a.length <=> b.length }
		standard = a.minmax { |a, b| a.length <=> b.length }
		assert_equal standard, result
	end


	def test_p1_max_1
		a = %w[dog alfdsfad horse]
		result = a.p1_max { |a, b| a.length <=> b.length }
		standard = a.max { |a, b| a.length <=> b.length }
		assert_equal standard, result
	end

	def test_p1_max_2
		a = %w[dog alfdsfad horse]
		b = %w[dog alfdsfad horse]
		result = a.p1_max
		standard = b.max
		assert_equal standard, result
	end

	def test_p1_max_3
		a = %w[dog alfdsfad horse]
		b = %w[dog alfdsfad horse]
		result = a.p1_max(2)
		standard = b.max(2)
		assert_equal standard, result
	end


	def test_p1_find_1
		result = (1..10).p1_find.to_a
		standard = (1..10).find.to_a
		assert_equal standard, result
	end

	def test_p1_find_2
		result = (1..10).p1_find { |i| i % 5 == 0 and i % 7 == 0 }
		standard = (1..10).find { |i| i % 5 == 0 and i % 7 == 0 }
		assert_equal standard, result
	end

	def test_p1_find_3
		result = (1..100).p1_find { |i| i % 5 == 0 and i % 7 == 0 }
		standard = (1..100).find { |i| i % 5 == 0 and i % 7 == 0 }
		assert_equal standard, result
	end

=begin
	def test_p1_each_with_index_1
		hash = Hash.new
		%w(cat dog wombat).p1_each_with_index { |item, index| hash[item] = index }
		result = hash
		hash2 = Hash.new
		%w(cat dog wombat).each_with_index { |item, index| hash2[item] = index }
		standard = hash2
		assert_equal standard, result
	end

	def test_p1_each_with_index_2
		hash = Hash.new
		["test", 1, 2].p1_each_with_index { |item, index| hash[item] = index }
		result = hash
		hash2 = Hash.new
		["test", 1, 2].each_with_index { |item, index| hash2[item] = index }
		standard = hash2
		assert_equal standard, result
	end

	def test_p1_each_with_index_3
		hash = Hash.new
		%w(cat dog bird tiger).p1_each_with_index { |item, index| hash[item] = index }
		result = hash
		hash2 = Hash.new
		%w(cat dog bird tiger).each_with_index { |item, index| hash2[item] = index }
		standard = hash2
		assert_equal standard, result
	end
=end
	def test_p1_chunk_1
		result = [3, 1, 4, 1].p1_chunk { |n| n.even? }.to_a
		standard = [3, 1, 4, 1].chunk { |n| n.even? }.to_a
		assert_equal standard, result
	end

	def test_p1_chunk_2
		result = [3, "test", 5, 7].p1_chunk { |n| n.is_a?(String) }.to_a
		standard = [3, "test", 5, 7].chunk { |n| n.is_a?(String) }.to_a
		assert_equal standard, result
	end

	def test_p1_chunk_3
		result = [3, -1, 4, 1, -5, 9, 2].p1_chunk { |n| n.even? }.to_a
		standard = [3, -1, 4, 1, -5, 9, 2].chunk { |n| n.even? }.to_a
		assert_equal standard, result
	end

	def test_p1_all_1
		result = %w[ant bear cat].p1_all? { |word| word.length >= 4 }
		standard = %w[ant bear cat].all? { |word| word.length >= 4 }
		assert_equal standard, result
	end

	def test_p1_all_2
		result = %w[ant bear cat].p1_all?(/t/)
		standard = %w[ant bear cat].all?(/t/)
		assert_equal standard, result
	end

	def test_p1_all_3
		result = [1, 2i, 3.14].p1_all?(Numeric)
		standard = [1, 2i, 3.14].all?(Numeric)
		assert_equal standard, result
	end

=begin
	def test_p1_collect_1
		result = (1..4).p1_collect { "cat" }
		standard = (1..4).collect { "cat" }
		assert_equal standard, result
	end

	def test_p1_collect_2
		result = (1..4).p1_collect { |i| i*i }
		standard = (1..4).collect { |i| i*i }
		assert_equal standard, result
	end

	def test_p1_collect_3
		result = (1..4).p1_collect
		standard = (1..4).collect.to_a
		assert_equal standard, result
	end
=end
	def test_p1_inject_1
		result = (5..10).p1_inject(2) { |product, n| product * n }
		standard = (5..10).inject(2) { |product, n| product * n }
		assert_equal standard, result
	end

	def test_p1_inject_2
		result = (5..10).p1_inject { |product, n| product * n }
		standard = (5..10).inject { |product, n| product * n }
		assert_equal standard, result
	end

	def test_p1_inject_3
		result = (5..10).p1_inject(:+)
		standard = (5..10).inject(:+)
		assert_equal standard, result
	end

end

# ZIYI_KOU

class P1Test < Minitest::Test	

	def test_inject
		array_sample=Array.new(10){ rand(0..10) }
		str_sample=Array.new(10){ rand(0..10).to_s }
		hash_sample=Hash.new
		hash_sample[rand(0..10)]=rand(0..10)
		hash_sample[rand(0..10)]=rand(0..10)
		extra_sample=Array.new

		assert_equal array_sample.p1_inject(:+),array_sample.inject(:+)
		assert_equal array_sample.p1_inject(1,:+),array_sample.inject(1,:+)
		assert_equal array_sample.p1_inject { |accumulator, item| accumulator+item}, array_sample.inject { |accumulator, item| accumulator+item}
		assert_equal str_sample.p1_inject { |accumulator, item| accumulator+item}, str_sample.inject { |accumulator, item| accumulator+item}
		assert_equal hash_sample.p1_inject {|accumulator, item| accumulator[item.last]=item.first;accumulator}, hash_sample.inject {|accumulator, item| accumulator[item.last]=item.first;accumulator}
		assert_nil extra_sample.p1_inject{|accumulator, item| accumulator+item},extra_sample.inject{|accumulator, item| accumulator+item}
	end
=begin
	def test_collect
		array_sample=Array.new(10){ rand(0..10) }
		str_sample=Array.new(10){ rand(0..10).to_s }
		hash_sample=Hash.new
		hash_sample[rand(0..10)]=rand(0..10)
		hash_sample[rand(0..10)]=rand(0..10)

		assert_equal array_sample.p1_collect {|item| item*2}, array_sample.collect {|item| item*2}
		assert_equal str_sample.p1_collect {|item| item+"x"}, str_sample.collect {|item| item+"x"}
		assert_equal hash_sample.p1_collect {|k,v| v*2}, hash_sample.collect {|k,v| v*2}
	end

	def test_select
		array_sample=Array.new(10){ rand(0..10) }
		str_sample=Array.new(10){ rand(1..1000).to_s }
		hash_sample=Hash.new
		hash_sample[rand(0..10)]=rand(0..10)
		hash_sample[rand(0..10)]=rand(0..10)
		extra_sample=Array.new

		assert_equal array_sample.p1_select {|item| item>5}, array_sample.select {|item| item>5}
		assert_equal str_sample.p1_select {|item| item.length>2}, str_sample.select {|item| item.length>2}
		assert_equal hash_sample.p1_select {|k,v| v*2}, hash_sample.select {|k,v| v*2}
		assert_equal extra_sample.p1_select {|item| item.length>2}, extra_sample.select {|item| item.length>2}
	end
=end
	def test_all
		array_sample=Array.new(10){ rand(0..10) }
		str_sample=Array.new(10){ rand(1..1000).to_s }
		str_sample2=Array.new(['ant','bear','cat'])
		hash_sample=Hash.new
		hash_sample[rand(0..10)]=rand(0..10)
		hash_sample[rand(0..10)]=rand(0..10)
		extra_sample=Array.new

		assert_equal array_sample.p1_all? {|item| item>5}, array_sample.all? {|item| item>5}
		assert_equal str_sample.p1_all? {|item| item.length>2}, str_sample.all? {|item| item.length>2}
		assert_equal hash_sample.p1_all? {|k,v| k>5}, hash_sample.all? {|k,v| k>5}
		assert_equal extra_sample.p1_all? {|item| item.length>2}, extra_sample.all? {|item| item.length>2}
		assert_equal str_sample2.p1_all?(/t/), str_sample2.all?(/t/)
		assert_equal str_sample2.p1_all?, str_sample2.all?
	end

	def test_chunk
		array_sample1=Array.new(10){ rand(0..10) }
		array_sample2=Array.new(10){ rand(0..10) }
		str_sample=Array.new(10){ rand(1..1000).to_s }

		assert_equal array_sample1.p1_chunk { |n| n.even?}.to_a,array_sample1.chunk { |n| n.even?}.to_a
		assert_equal Array.new(array_sample2.p1_chunk { |n| n.even?}.collect {|x,y| y}),Array.new(array_sample2.chunk { |n| n.even?}.collect {|x,y| y})
		assert_equal str_sample.p1_chunk { |n| n.length}.to_a,str_sample.chunk { |n| n.length}.to_a
	end
=begin
	def test_each_with_index
		array_sample=Array.new(10){ rand(0..10) }
		str_sample=Array.new(10){ rand(1..1000).to_s }
		hash_sample=Hash.new
		hash_sample[rand(0..10)]=rand(0..10)
		hash_sample[rand(0..10)]=rand(0..10)
		test_repo=[]
		gt_repo=[]


		assert_equal array_sample.p1_each_with_index {|item,index| puts "index: #{index} for #{item}"},array_sample.each_with_index {|item,index| puts "index: #{index} for #{item}"}
		str_sample.p1_each_with_index {|item,index| test_repo<<index}
		str_sample.each_with_index {|item,index| gt_repo<<index}
		assert_equal test_repo,gt_repo
		hash_sample.p1_each_with_index {|item,index| test_repo<<item}
		hash_sample.each_with_index {|item,index| gt_repo<<item}
		assert_equal test_repo,gt_repo
	end
=end
	def test_find
		array_sample=Array.new(10){ rand(0..10) }
		str_sample=Array.new(10){ rand(1..1000).to_s }
		hash_sample=Hash.new
		hash_sample[rand(0..10)]=rand(0..10)
		hash_sample[rand(0..10)]=rand(0..10)

		assert_equal array_sample.p1_find {|item| item>1},array_sample.find {|item| item>1}
		assert_equal str_sample.p1_find {|item| item.length>2},str_sample.find {|item| item.length>1}
		assert_equal hash_sample.p1_find {|item| item.first>1},hash_sample.find {|item| item.first>1}
	end

	def test_max
		array_sample1=Array.new
		array_sample2=Array.new([3,2,6,3])
		str_sample=Array.new(['albatross','dog','horse'])

		assert_nil array_sample1.p1_max,array_sample1.max
		assert_equal array_sample2.p1_max(2),array_sample2.max(2)
		assert_equal str_sample.p1_max,str_sample.max
		assert_equal str_sample.p1_max {|a, b| a.length <=> b.length},str_sample.max {|a, b| a.length <=> b.length}
		assert_equal str_sample.p1_max(2) {|a, b| a.length <=> b.length},str_sample.max(2) {|a, b| a.length <=> b.length}
	end

	def test_minmax
		array_sample1=Array.new
		array_sample2=Array.new([1])
		array_sample3=Array.new([3,2,6,3])
		str_sample=Array.new(['albatross','dog','horse'])

		assert_equal array_sample1.p1_minmax,array_sample1.minmax
		assert_equal array_sample2.p1_minmax,array_sample2.minmax
		assert_equal array_sample3.p1_minmax,array_sample3.minmax
		assert_equal str_sample.p1_minmax,str_sample.minmax
		assert_equal str_sample.p1_minmax {|a, b| a.length <=> b.length},str_sample.minmax {|a, b| a.length <=> b.length}
	end
	
	def test_slice_after
		array_sample=Array.new(10){ rand(0..10) }
		str_sample=Array.new(["foo\n", "bar\\\n", "baz\n", "\n", "qux\n"])
		str_sample2=Array.new(["bar\\\n"])

		assert_equal array_sample.p1_slice_after {|item| item.even?}.to_a, array_sample.slice_after {|item| item.even?}.to_a
		assert_equal str_sample.p1_slice_after(/(?<!\\)\n\z/).to_a,str_sample.slice_after(/(?<!\\)\n\z/).to_a
		assert_equal str_sample2.p1_slice_after(/(?<!\\)\n\z/).to_a,str_sample2.slice_after(/(?<!\\)\n\z/).to_a
	end
=begin
	def test_zip
		a = Array.new([ 4, 5, 6 ])
		b = Array.new([ 7, 8, 9 ])
		c_test = []
		c_gt=[]

		assert_equal a.zip(),a.p1_zip()
		assert_equal Array.new([1, 2]).p1_zip(a,b),Array.new([1, 2]).zip(a,b)
		a.p1_zip(b) { |x, y| c_test << x + y }
		a.zip(b) {|x, y| c_gt << x + y}
		assert_equal c_test,c_gt
	end
=end
end

