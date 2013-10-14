# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#reverse' do
  subject { object.reverse(args) }

  let(:adapter)  { double('Adapter')                         }
  let(:relation) { double('Relation', :reverse => response)  }
  let(:response) { double('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)    }
  let(:args)     { double                                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#reverse' do
    expect(relation).to receive(:reverse).with(args)
    subject
  end
end
