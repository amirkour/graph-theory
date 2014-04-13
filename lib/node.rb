
module GraphTheory
	class Node
		attr_accessor :number, :visited, :payload
		def initialize(options={})
			@number=options[:number] || -1
			@visited=options[:visited] || false
			@payload=options[:payload] || nil
		end

		# equality as we typically think of it
		def ==(other)
			self.eql?(other)
		end

		# equality that has to be consistent with 'hash'
		# ie: self.eql?(other) iff self.hash==other.hash
		def eql?(other)
			other.kind_of?(Node) ? @payload.eql?(other.payload) : false
		end

		# has to be consistent w/ eql?
		def hash
			@payload.hash
		end

		def to_s
			payload=@payload.nil? ? 'none' : @payload.to_s
			"{NODE - Payload: #{payload} - Number: #{@number} - Visited: #{@visited}}"
		end

		# only true when self and other are exactly the same object
		# don't need to implement it - ruby object provides it
		#
		# def equal?(other)
		# end
	end
end

