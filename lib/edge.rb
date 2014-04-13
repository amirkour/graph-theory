
module GraphTheory
	class Edge
		attr_accessor :origin, :terminus
		def initialize(options={})
			@origin=options[:origin] || nil
			@terminus=options[:terminus] || nil
		end

		def ==(other)
			self.eql?(other)
		end

		def eql?(other)
			other.kind_of?(Edge) ? @origin==other.origin && @terminus==other.terminus : false
		end

		def hash
			@origin.hash ^ @terminus.hash
		end

		def to_s
			"{EDGE #{@origin.to_s} - #{@terminus.to_s}}"
		end
	end
end
