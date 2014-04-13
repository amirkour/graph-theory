require 'graph-theory'
include GraphTheory

describe Node do
	describe "#== and #eql?" do
		context "when all properties are ==" do
			it "returns true" do
				a=Node.new(:payload=>1, :number=>1, :visited=>true)
				b=Node.new(:payload=>1, :number=>1, :visited=>true)
				expect(a).to eq(b)
				expect(b).to eq(a)
				expect(a).to eql(b)
				expect(b).to eql(a)
			end
		end
		context "when only the payload properties are ==" do
			it "returns true" do
				a=Node.new(:payload=>1, :number=>1, :visited=>true)
				b=Node.new(:payload=>1, :number=>2, :visited=>false)
				expect(a).to eq(b)
				expect(b).to eq(a)
				expect(a).to eql(b)
				expect(b).to eql(a)
			end
		end
		context "when the payload properties are !=" do
			it "returns false even when everything else is !=" do
				a=Node.new(:payload=>1, :number=>1, :visited=>true)
				b=Node.new(:payload=>2, :number=>2, :visited=>false)
				expect(a).to_not eq(b)
				expect(b).to_not eq(a)
				expect(a).to_not eql(b)
				expect(b).to_not eql(a)
			end
			it "returns false even when everything else is ==" do
				a=Node.new(:payload=>1, :number=>1, :visited=>true)
				b=Node.new(:payload=>2, :number=>1, :visited=>true)
				expect(a).to_not eq(b)
				expect(b).to_not eq(a)
				expect(a).to_not eql(b)
				expect(b).to_not eql(a)
			end
		end
		context "against objects where kind_of?(Node) == false" do
			it "returns false" do
				a=Node.new(:payload=>1, :number=>1, :visited=>true)
				b=Object.new
				expect(a).to_not eq(b)
				expect(b).to_not eq(a)
				expect(a).to_not eql(b)
				expect(b).to_not eql(a)
			end
		end
	end
	# == ad eql?

	describe "#hash" do
		it "returns the hashcode of the payload property" do
			original_payload=1
			a=Node.new(:payload=>original_payload, :number=>2, :visited=>false)

			original_hash=a.hash
			expect(original_hash).to eq(original_payload.hash)

			# now change up everything but the payload, the hash should be the same
			a.number+=1
			a.visited=!a.visited
			expect(a.hash).to eq(original_hash)
			expect(a.hash).to eq(original_payload.hash)

			# now change the payload - the hash should no longer be the same as the original
			a.payload=original_payload+1
			expect(a.hash).to_not eq(original_hash)
			expect(a.hash).to eq(a.payload.hash)
		end
	end
	# hash
end
