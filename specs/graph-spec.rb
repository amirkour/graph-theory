require 'graph-theory'
include GraphTheory

describe Graph do
	describe "#== and #eql?" do
		it "simply delegates to node and edge equality" do

			node_one=Node.new(:payload=>1)
			node_two=Node.new(:payload=>2)
			edge_the_onesie=Edge.new(:origin=>node_one, :terminus=>node_two)

			nodes=[node_one, node_two]
			edges=[edge_the_onesie]

			a=Graph.new(:nodes=>nodes, :edges=>edges)

			node_one=Node.new(:payload=>3)
			node_two=Node.new(:payload=>4)
			nodes=[node_one,node_two]

			b=Graph.new(:nodes=>nodes,:edges=>edges)

			expect(a).to_not eq(b)
			expect(b).to_not eq(a)
			expect(a).to_not eql(b)
			expect(b).to_not eql(a)

			a.nodes=[Node.new(:payload=>10), Node.new(:payload=>11)]
			b.nodes=[Node.new(:payload=>10), Node.new(:payload=>11)]
			expect(a).to eq(b)
			expect(b).to eq(a)
			expect(a).to eql(b)
			expect(b).to eql(a)
		end
	end
	# == and eql?

	describe "#hash" do
		it "is simply nodes ^ edges" do
			node_one=Node.new(:payload=>1)
			node_two=Node.new(:payload=>2)
			edge_the_onesie=Edge.new(:origin=>node_one, :terminus=>node_two)

			nodes=[node_one, node_two]
			edges=[edge_the_onesie]

			a=Graph.new(:nodes=>nodes, :edges=>edges)
			expect(a.hash).to eq(nodes.hash ^ edges.hash)
		end
	end
	# hash

	describe "#get_neighbors_for" do
		before :all do
			@node_a=Node.new :payload=>'a'
			@node_b=Node.new :payload=>'b'
			@node_c=Node.new :payload=>'c'
			@node_d=Node.new :payload=>'d'

			@edge_a_to_b=Edge.new :origin=>@node_a, :terminus=>@node_b
			@edge_b_to_c=Edge.new :origin=>@node_b, :terminus=>@node_c
			@edge_b_to_d=Edge.new :origin=>@node_b, :terminus=>@node_d

			@graph=Graph.new :nodes=>[@node_a,@node_b,@node_c,@node_d], :edges=>[@edge_a_to_b, @edge_b_to_c, @edge_b_to_d]
		end
		context "without a block" do
			it "returns an empty list when called with nil" do
				empty_list=@graph.get_neighbors_for(nil)
				expect(empty_list).to_not be_nil
				expect(empty_list).to be_a_kind_of(Array)
				expect(empty_list.length).to eq(0)
			end
			it "returns a list of all neighbors for the given node" do
				neighbors_of_a=@graph.get_neighbors_for(@node_a)
				expect(neighbors_of_a.length).to eq(1)
				expect(neighbors_of_a).to eq([@node_b])

				neighbors_of_b=@graph.get_neighbors_for(@node_b)
				expect(neighbors_of_b.length).to eq(2)
				expect(neighbors_of_b).to eq([@node_c, @node_d])
			end
			it "returns an empty list when called for a node not in the graph" do
				empty_list=@graph.get_neighbors_for(Node.new)
				expect(empty_list.length).to eq(0)
			end
			it "returns a empty list when called for a node without neighbors" do
				empty_list=@graph.get_neighbors_for(@node_d)
				expect(empty_list.length).to eq(0)
			end
		end
		# #get_neighbors_for w/o a block

		context "with a block" do
			it "will yield the neighbors to the block" do
				expect { |test_block| @graph.get_neighbors_for(@node_a, &test_block) }.to yield_successive_args(@node_b)
				expect { |test_block| @graph.get_neighbors_for(@node_b, &test_block) }.to yield_successive_args(@node_c, @node_d)
				expect { |test_block| @graph.get_neighbors_for(@node_c, &test_block) }.to_not yield_control
			end
			it "returns the resulting neighbor list" do
				neighbors=@graph.get_neighbors_for(@node_a){|x|}
				expect(neighbors).to eq([@node_b])
			end
		end
		# get_neighbors_for w/ a block

	end
	# get_neighbors_for

	describe "#add_node" do
		it "adds the given node to the list of nodes" do
			graph=Graph.new :nodes=>[]
			expect(graph.nodes.length).to eq(0)

			graph.add_node Node.new
			expect(graph.nodes.length).to eq(1)
		end
		it "won't add the same node more than once" do
			a=Node.new :payload=>'foo'
			graph=Graph.new
			graph.add_node(a)

			expect(graph.nodes.length).to eq(1)

			graph.add_node(a)
			expect(graph.nodes.length).to eq(1)
		end
		it "won't add non-node objects to the list of nodes" do
			graph=Graph.new :nodes=>[]
			expect(graph.nodes.length).to eq(0)

			graph.add_node(Object.new)
			graph.add_node(nil)
			graph.add_node(Edge.new)
			expect(graph.nodes.length).to eq(0)
		end
	end
	# add_node

	describe "#add_edge" do
		before :all do
			@origin=Node.new :payload=>'origin'
			@terminus=Node.new :payload=>'terminus'
		end
		after :each do

		end
		it "adds an edge between the given nodes to the graph" do
			graph=Graph.new		
			expect(graph.edges.length).to eq(0)

			graph.add_edge(@origin, @terminus)
			expect(graph.edges.length).to eq(1)

			edge_from_graph=graph.edges[0] if graph.edges.length >= 0
			edge_that_should_be_equals=Edge.new :origin=>@origin, :terminus=>@terminus
			expect(edge_that_should_be_equals).to eq(edge_from_graph)
		end
		it "adds the nodes of the new edge to the graph" do
			graph=Graph.new
			expect(graph.nodes.length).to eq(0)
			graph.add_edge(@origin,@terminus)
			expect(graph.nodes.length).to eq(2)
			expect(graph.nodes.include? @origin).to be_true
			expect(graph.nodes.include? @terminus).to be_true
		end
		it "won't add the same edge twice" do
			graph=Graph.new
			graph.add_edge(@origin,@terminus)
			graph.add_edge(@origin,@terminus)
			graph.add_edge(@origin,@terminus)
			expect(graph.edges.length).to eq(1)
		end
		it "won't add an edge if either of the args is not a Node" do
			graph=Graph.new
			graph.add_edge(@origin,nil)
			graph.add_edge(nil,@origin)
			graph.add_edge(Edge.new, nil)
			expect(graph.edges.length).to eq(0)
		end
	end
	# add_edge

	describe "#delete_node" do
		before :all do
			@node=Node.new :payload=>'delete_node test node'
		end
		it "removes the given node from the list of nodes" do
			graph=Graph.new :nodes=>[@node, Node.new]
			expect(graph.nodes.length).to eq(2)

			graph.delete_node @node
			expect(graph.nodes.length).to eq(1)
		end
		it "removes/returns all edges starting at the given node" do
			graph=Graph.new
			graph.add_edge(@node, Node.new(:payload=>1))
			graph.add_edge(@node, Node.new(:payload=>2))
			graph.add_edge(Node.new(:payload=>1), Node.new(:payload=>2))

			edges_removed=graph.delete_node(@node)
			expect(edges_removed).to_not be_nil
			expect(edges_removed).to be_a_kind_of(Array)
			expect(edges_removed.length).to eq(2)
			expect(graph.edges.length).to eq(1)
			expect(graph.nodes.length).to eq(2)
			expect(graph.edges.length).to eq(1)
		end
		it "removes/returns all edges ending at the given node" do
			graph=Graph.new
			graph.add_edge(Node.new(:payload=>1), @node)
			graph.add_edge(Node.new(:payload=>2), @node)
			graph.add_edge(Node.new(:payload=>1), Node.new(:payload=>2))

			edges_removed=graph.delete_node(@node)
			expect(edges_removed).to_not be_nil
			expect(edges_removed).to be_a_kind_of(Array)
			expect(edges_removed.length).to eq(2)
			expect(graph.edges.length).to eq(1)
			expect(graph.nodes.length).to eq(2)
			expect(graph.edges.length).to eq(1)
		end
		it "returns an empty list, even if the given node is not kind_of?(Node)" do
			graph=Graph.new
			expect(graph.delete_node(nil)).to_not be_nil
			expect(graph.delete_node(Edge.new)).to_not be_nil
			expect(graph.delete_node(Edge.new)).to be_a_kind_of(Array)
			expect(graph.delete_node(Object.new).length).to eq(0)
		end
	end
	# delete_node

	describe "#delete_edge" do
		before :all do
			@origin=Node.new :payload=>'origin'
			@terminus=Node.new :payload=>'terminus'
			@dummy=Node.new :payload=>'dummy node'
		end
		it "removes/returns the edge between the given nodes" do
			graph=Graph.new
			graph.add_edge(@origin,@terminus)
			graph.add_edge(@origin,@dummy)
			removed_edge=graph.delete_edge(@origin,@terminus)

			expect(graph.edges.length).to eq(1)
			expect(removed_edge).to eq(Edge.new(:origin=>@origin, :terminus=>@terminus))
		end
		it "does not remove the nodes of the removed edge" do
			graph=Graph.new
			graph.add_edge(@origin,@terminus)
			graph.add_edge(@origin,@dummy)
			removed_edge=graph.delete_edge(@origin,@terminus)

			expect(graph.nodes.length).to eq(3)
		end
		it "returns nil if there is no edge between the given nodes" do
			graph=Graph.new
			graph.add_edge(@origin,@terminus)
			graph.add_edge(@origin,@dummy)
			removed_edge=graph.delete_edge(@terminus,@origin)
			expect(removed_edge).to be_nil
		end
		it "returns nil if either of the given params is not a Node object" do
			graph=Graph.new
			graph.add_edge(@origin,@terminus)
			graph.add_edge(@origin,@dummy)
			
			expect(graph.delete_edge(nil,@terminus)).to be_nil
			expect(graph.delete_edge(@origin,nil)).to be_nil
		end
	end
	# delete_edge
end