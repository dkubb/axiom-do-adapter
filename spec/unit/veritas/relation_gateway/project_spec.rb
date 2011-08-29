# encoding: utf-8

require 'spec_helper'
require 'veritas/relation_gateway'

describe RelationGateway, '#project' do
  subject { object.project(args) }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :project => response)  }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }
  let(:gateway)  { mock('New Gateway')                     }

  before do
    described_class.stub!(:new).and_return(gateway)
  end

  it { should equal(gateway) }

  it 'initializes the new gateway with the adapter' do
    described_class.should_receive(:new).with(adapter, anything)
    subject
  end

  it 'initializes the new gateway with the response' do
    described_class.should_receive(:new).with(anything, response)
    subject
  end

  it 'forwards the arguments to relation#project' do
    relation.should_receive(:project).with(args)
    subject
  end

  it 'tests the response is a relation' do
    response.should_receive(:kind_of?).with(Relation)
    subject
  end
end
