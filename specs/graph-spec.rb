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
end