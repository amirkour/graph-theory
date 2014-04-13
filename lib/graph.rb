
module GraphTheory
	class Graph
		attr_accessor :nodes, :edges
		def initialize(options={})
			@nodes=options[:nodes] || []
			@edges=options[:edges] || []
		end

		def get_neighbors_for(origin_node, &block)
			return [] if @edges.nil? || @edges.length <= 0 || origin_node.nil?

			neighbors=@edges.inject([]) do |list_to_inject, next_edge|
				list_to_inject << next_edge.terminus if next_edge.origin==origin_node
				list_to_inject
			end

			neighbors.each{ |neighbor| block.call(neighbor) } if block
			neighbors
		end

		def ==(other)
			self.eql?(other)
		end

		def eql?(other)
			other.kind_of?(Graph) ? @nodes==other.nodes && @edges==other.edges : false
		end

		def hash
			@nodes.hash ^ @edges.hash
		end

		def to_s
			"Nodes: #{@nodes.to_s} - Edges: #{@edges.to_s}"
		end
	end
end
