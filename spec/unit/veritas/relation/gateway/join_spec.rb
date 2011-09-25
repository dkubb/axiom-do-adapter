# encoding: utf-8

require 'spec_helper'
require 'veritas/relation/gateway'

describe Relation::Gateway, '#join' do
  subject { object.join(other) }

  let(:adapter)         { mock('Adapter')                        }
  let(:relation)        { mock('Relation')                       }
  let(:object)          { described_class.new(adapter, relation) }
  let(:operation)       { :join                                  }
  let(:factory)         { Algebra::Join                          }
  let(:binary_relation) { mock(factory)                          }

  it_should_behave_like 'a binary relation method'

  context 'when passed a block' do
    subject { object.join(other, &block) }

    let(:other_relation) { mock('Other Relation')                       }
    let(:other)          { described_class.new(adapter, other_relation) }
    let(:gateway)        { mock('Other Gateway')                        }
    let(:join)           { mock('Join', :restrict => gateway)           }
    let(:block)          { proc {}                                      }

    before do
      relation.stub!(operation).and_return(join)
    end

    it { should equal(gateway) }

    it 'passes the other relation to the join operation' do
      relation.should_receive(operation).with(other_relation)
      subject
    end

    it 'passes the block to the join relation' do
      join.stub!(:restrict) do |proc|
        proc.should equal(block)
      end
      subject
    end
  end
end
