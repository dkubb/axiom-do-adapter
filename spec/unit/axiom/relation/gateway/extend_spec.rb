# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#extend' do
  subject { object.extend(args, &block) }

  let(:adapter)  { double('Adapter')                         }
  let(:relation) { double('Relation', extend: response)      }
  let(:response) { double('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)    }
  let(:args)     { double                                    }
  let(:block)    { ->(context) { }                           }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#extend' do
    expect(relation).to receive(:extend).with(args)
    subject
  end

  unless testing_block_passing_broken?
    it 'forwards the block to relation#extend' do
      expect(relation).to receive(:extend) { |&proc| expect(proc).to equal(block) }
      subject
    end
  end
end
