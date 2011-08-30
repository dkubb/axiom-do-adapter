# encoding: utf-8

require 'spec_helper'
require 'veritas/relation/gateway'

describe Relation::Gateway, '#optimize' do
  subject { object.optimize }

  let(:adapter)  { stub                                   }
  let(:relation) { mock('Relation')                       }
  let(:object)   { described_class.new(adapter, relation) }

  before do
    relation.stub!(:optimize).and_return(relation)
  end

  it { should equal(object) }

  it 'forwards the message to relation#optimize' do
    relation.should_receive(:optimize).with(no_args)
    subject
  end
end
