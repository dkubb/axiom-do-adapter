# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#restrict' do
  subject { object.restrict(args, &block) }

  let(:adapter)  { double('Adapter')                         }
  let(:relation) { double('Relation', restrict: response)    }
  let(:response) { double('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)    }
  let(:args)     { double                                    }
  let(:block)    { ->(context) { }                           }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#restrict' do
    expect(relation).to receive(:restrict).with(args)
    subject
  end

  it 'forwards the block to relation#restrict' do
    expect(relation).to receive(:restrict) { |_args, &proc| expect(proc).to equal(block) }
    subject
  end
end
