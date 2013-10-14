# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#remove' do
  subject { object.remove(args) }

  let(:adapter)  { double('Adapter')                         }
  let(:relation) { double('Relation', :remove => response)   }
  let(:response) { double('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)    }
  let(:args)     { double                                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#remove' do
    expect(relation).to receive(:remove).with(args)
    subject
  end
end
