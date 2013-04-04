# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#rename' do
  subject { object.rename(args) }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :rename => response)   }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#rename' do
    relation.should_receive(:rename).with(args)
    subject
  end
end
