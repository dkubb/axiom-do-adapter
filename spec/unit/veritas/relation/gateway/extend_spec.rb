# encoding: utf-8

require 'spec_helper'
require 'veritas/relation/gateway'

describe Relation::Gateway, '#extend' do
  subject { object.extend(args, &block) }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :extend => response)   }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }
  let(:block)    { proc {}                                 }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#extend' do
    relation.should_receive(:extend).with(args)
    subject
  end

  it 'forwards the block to relation#extend' do
    relation.stub!(:extend) { |_args, proc| proc.should equal(block) }
    subject
  end
end
