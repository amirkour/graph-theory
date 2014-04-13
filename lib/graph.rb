
module GraphTheory
	class Graph
		attr_accessor :nodes, :edges
		def initialize(options={})
			@nodes=options[:nodes] || []
			@edges=options[:edges] || []
		end

		def add_node(node_to_add)
			return nil if node_to_add.nil?
			return nil unless node_to_add.kind_of?(Node)
			@nodes=[] if @nodes.nil?
			
			@nodes << node_to_add unless @nodes.include? node_to_add
			node_to_add
		end

		def add_edge(origin_node, terminus_node)
			return nil unless origin_node.kind_of?(Node) && terminus_node.kind_of?(Node)
			@edges=[] if @edges.nil?

			new_edge=Edge.new :origin=>origin_node, :terminus=>terminus_node
			unless @edges.include? new_edge
				@edges << new_edge
				self.add_node(origin_node)
				self.add_node(terminus_node)
			end

			new_edge
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
