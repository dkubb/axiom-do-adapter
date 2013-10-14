# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#optimize' do
  subject { object.optimize }

  let(:adapter)  { double                                 }
  let(:relation) { double('Relation')                     }
  let(:object)   { described_class.new(adapter, relation) }

  before do
    allow(relation).to receive(:optimize).and_return(relation)
  end

  it_should_behave_like 'a command method'

  it 'forwards the message to relation#optimize' do
    expect(relation).to receive(:optimize).with(no_args)
    subject
  end
end
