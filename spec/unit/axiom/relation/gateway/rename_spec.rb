# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#rename' do
  subject { object.rename(args) }

  let(:adapter)  { double('Adapter')                         }
  let(:relation) { double('Relation', :rename => response)   }
  let(:response) { double('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)    }
  let(:args)     { double                                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#rename' do
    expect(relation).to receive(:rename).with(args)
    subject
  end
end
