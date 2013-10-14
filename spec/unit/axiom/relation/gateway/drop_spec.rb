# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#drop' do
  subject { object.drop(args) }

  let(:adapter)  { double('Adapter')                         }
  let(:relation) { double('Relation', :drop => response)     }
  let(:response) { double('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)    }
  let(:args)     { double                                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#drop' do
    expect(relation).to receive(:drop).with(args)
    subject
  end
end
