# encoding: utf-8

require 'spec_helper'
require 'veritas/relation_gateway'

describe RelationGateway, '#join' do
  subject { object.join(other) }

  let(:adapter)  { mock('Adapter')                        }
  let(:relation) { mock('Relation')                       }
  let(:object)   { described_class.new(adapter, relation) }
  let(:join)     { mock('Join')                           }

  describe 'when other has the same adapter' do
    let(:other_relation) { mock('Other Relation')                       }
    let(:other)          { described_class.new(adapter, other_relation) }

    before do
      relation.stub!(:join).and_return(join)
    end

    it { should equal(join) }

    it 'passes the other relation to the join' do
      relation.should_receive(:join).with(other_relation)
      subject
    end
  end

  describe 'when other has a different adapter' do
    let(:other_adapter) { mock('Other Adapter')                    }
    let(:other)         { described_class.new(other_adapter, stub) }

    before do
      Algebra::Join.stub!(:new).and_return(join)
    end

    it { should equal(join) }

    it 'initializes the join with the gateway' do
      Algebra::Join.should_receive(:new).with(object, anything)
      subject
    end

    it 'initializes the join with the other gateway' do
      Algebra::Join.should_receive(:new).with(anything, other)
      subject
    end
  end

  describe 'when other has no adapter' do
    let(:other) { mock('Other Relation') }

    before do
      Algebra::Join.stub!(:new).and_return(join)
    end

    it { should equal(join) }

    it 'initializes the join with the gateway' do
      Algebra::Join.should_receive(:new).with(object, anything)
      subject
    end

    it 'initializes the join with the other relation' do
      Algebra::Join.should_receive(:new).with(anything, other)
      subject
    end
  end
end
