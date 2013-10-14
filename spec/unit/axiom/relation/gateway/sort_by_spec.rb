# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#sort_by' do
  subject { object.sort_by(args, &block) }

  let(:adapter)  { double('Adapter')                         }
  let(:relation) { double('Relation', sort_by: response)     }
  let(:response) { double('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)    }
  let(:args)     { double                                    }
  let(:block)    { ->(context) { }                           }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#sort_by' do
    expect(relation).to receive(:sort_by).with(args)
    subject
  end

  it 'forwards the block to relation#sort_by' do
    expect(relation).to receive(:sort_by) { |&proc| expect(proc).to equal(block) }
    subject
  end
end
