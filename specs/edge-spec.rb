require 'graph-theory'
include GraphTheory

describe Edge do
	describe "#== and #eql?" do
		context "where the origin and terminus nodes are ==" do
			it "returns true" do
				a_origin=Node.new(:payload=>1)
				a_terminus=Node.new(:payload=>1)
				b_origin=Node.new(:payload=>1)
				b_terminus=Node.new(:payload=>1)

				a=Edge.new(:origin=>a_origin, :terminus=>a_terminus)
				b=Edge.new(:origin=>b_origin, :terminus=>b_terminus)

				expect(a).to eq(b)
				expect(b).to eq(a)
				expect(a).to eql(b)
				expect(b).to eql(a)
			end
		end
		context "where the start and end nodes are !=" do
			it "returns false" do
				a_origin=Node.new(:payload=>1)
				a_terminus=Node.new(:payload=>1)
				b_origin=Node.new(:payload=>2)
				b_terminus=Node.new(:payload=>2)

				a=Edge.new(:origin=>a_origin, :terminus=>a_terminus)
				b=Edge.new(:origin=>b_origin, :terminus=>b_terminus)

				expect(a).to_not eq(b)
				expect(b).to_not eq(a)
				expect(a).to_not eql(b)
				expect(b).to_not eql(a)
			end
		end
		context "for an object that isn't an Edge" do
			it "returns false" do
				expect(Object.new).to_not eq(Edge.new)
				expect(Object.new).to_not eql(Edge.new)
			end
		end
	end
	# == and eql?

	describe "#hash" do
		it "is just origin ^ terminus" do
			origin=Node.new
			terminus=Node.new
			a=Edge.new(:origin=>origin, :terminus=>terminus)

			expect(a.hash).to eq(origin.hash ^ terminus.hash)
		end
	end
	# hash
end
