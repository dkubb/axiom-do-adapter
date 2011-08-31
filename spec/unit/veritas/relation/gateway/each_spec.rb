# encoding: utf-8

require 'spec_helper'
require 'veritas/relation/gateway'

describe Relation::Gateway, '#each' do
  subject { object.each { |tuple| yields << tuple } }

  let(:header)   { mock('Header')                         }
  let(:reader)   { mock('Reader')                         }
  let(:tuple)    { mock('Tuple')                          }
  let(:adapter)  { mock('Adapter')                        }
  let(:relation) { mock('Relation')                       }
  let!(:object)  { described_class.new(adapter, relation) }
  let(:yields)   { []                                     }

  context 'with an unmaterialized relation' do
    let(:wrapper) { stub }

    before do
      adapter.stub!(:read).and_return(reader)

      relation.stub!(:header).and_return(header)
      relation.stub!(:materialized?).and_return(false)
      relation.stub!(:each).and_return(relation)

      wrapper.stub!(:each).and_yield(tuple)
      Relation.stub!(:new).and_return(wrapper)
    end

    it_should_behave_like 'an #each method'

    it 'yields each tuple' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to([ tuple ])
    end

    it 'passes in the relation to the adapter reader' do
      adapter.should_receive(:read).with(relation)
      subject
    end

    it 'passes in the relation header and reader to the wrapper constructor' do
      Relation.should_receive(:new).with(header, reader)
      subject
    end
  end

  context 'with a materialized relation' do
    before do
      relation.stub!(:materialized?).and_return(true)

      # I do not know a better way to mock this behaviour out and
      # I'm pretty sure that rspec does not provide Enumerator helpers
      relation.stub!(:each) do |*args|
        if args.empty?
          relation.to_enum
        else
          args.first.call(tuple)
          relation
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
      adapter.should_not_receive(:read)
      subject
    end

    it 'does not create a wrapper' do
      Relation.should_not_receive(:new)
      subject
    end
  end
end
