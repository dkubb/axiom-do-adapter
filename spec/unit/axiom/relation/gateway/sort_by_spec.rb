# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#sort_by' do
  subject { object.sort_by(args, &block) }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :sort_by => response)  }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }
  let(:block)    { lambda { |context| }                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#sort_by' do
    relation.should_receive(:sort_by).with(args)
    subject
  end

  unless testing_block_passing_broken?
    it 'forwards the block to relation#sort_by' do
      relation.should_receive(:sort_by) { |&proc| proc.should equal(block) }
      subject
    end
  end
end
