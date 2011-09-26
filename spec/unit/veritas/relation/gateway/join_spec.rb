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
    subject { object.join(other) { |context| yields << context } }

    let(:other_relation) { mock('Other Relation')                       }
    let(:other)          { described_class.new(adapter, other_relation) }
    let(:gateway)        { mock('Other Gateway')                        }
    let(:product)        { mock('Product', :restrict => gateway)        }
    let(:yields)         { []                                           }

    before do
      relation.stub!(:product).and_return(product)
    end

    it { should equal(gateway) }

    it 'passes the other relation to the product operation' do
      relation.should_receive(:product).with(other_relation)
      subject
    end

    it 'passes the block to the product relation' do
      context = mock('Context')
      product.should_receive(:restrict).and_yield(context)
      expect { subject }.to change { yields.dup }.from([]).to([ context ])
    end
  end
end
