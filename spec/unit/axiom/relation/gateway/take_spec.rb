# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#take' do
  subject { object.take(args) }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :take => response)     }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#take' do
    relation.should_receive(:take).with(args)
    subject
  end
end
