# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#each' do
  subject { object.each { |tuple| yields << tuple } }

  let(:header)   { double('Header')                       }
  let(:reader)   { double('Reader')                       }
  let(:tuple)    { double('Tuple')                        }
  let(:adapter)  { double('Adapter')                      }
  let(:relation) { double('Relation')                     }
  let!(:object)  { described_class.new(adapter, relation) }
  let(:yields)   { []                                     }

  context 'with an unmaterialized relation' do
    let(:wrapper) { double }

    before do
      allow(adapter).to receive(:read).and_return(reader)

      allow(relation).to receive(:header).and_return(header)
      allow(relation).to receive(:materialized?).and_return(false)
      allow(relation).to receive(:each).and_return(relation)

      allow(wrapper).to receive(:each).and_yield(tuple)
      allow(Relation).to receive(:new).and_return(wrapper)
    end

    it_should_behave_like 'an #each method'

    it 'yields each tuple' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to([ tuple ])
    end

    it 'passes in the relation to the adapter reader' do
      expect(adapter).to receive(:read).with(relation)
      subject
    end

    it 'passes in the relation header and reader to the wrapper constructor' do
      expect(Relation).to receive(:new).with(header, reader)
      subject
    end
  end

  context 'with a materialized relation' do
    before do
      allow(relation).to receive(:materialized?).and_return(true)

      tuple = self.tuple

      # I do not know a better way to mock this behaviour out and
      # I'm pretty sure that rspec does not provide Enumerator helpers
      relation.define_singleton_method(:each) do |&block|
        if block
          block.call(tuple)
          self
        else
          to_enum
        end
      end
    end

    it_should_behave_like 'an #each method'

    it 'yields each tuple' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to([ tuple ])
    end

    it 'does not create a reader' do
      expect(adapter).not_to receive(:read)
      subject
    end

    it 'does not create a wrapper' do
      expect(Relation).not_to receive(:new)
      subject
    end
  end
end
