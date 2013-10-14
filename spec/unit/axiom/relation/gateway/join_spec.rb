# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#join' do
  subject { object.join(other) }

  let(:adapter)         { double('Adapter')                      }
  let(:relation)        { double('Relation')                     }
  let(:object)          { described_class.new(adapter, relation) }
  let(:operation)       { :join                                  }
  let(:factory)         { Algebra::Join                          }
  let(:binary_relation) { double(factory)                        }

  it_should_behave_like 'a binary relation method'

  context 'when passed a block' do
    subject { object.join(other) { |context| yields << context } }

    let(:other_relation) { double('Other Relation')                     }
    let(:other)          { described_class.new(adapter, other_relation) }
    let(:gateway)        { double('Other Gateway')                      }
    let(:join)           { double('Join', :restrict => gateway)         }
    let(:yields)         { []                                           }

    before do
      allow(Algebra::Join).to receive(:new).with(relation, other_relation).and_return(join)
    end

    it { should equal(gateway) }

    it 'passes the relations to the join constructor' do
      expect(Algebra::Join).to receive(:new).with(relation, other_relation)
      subject
    end

    it 'passes the block to the join relation' do
      context = double('Context')
      expect(join).to receive(:restrict).and_yield(context)
      expect { subject }.to change { yields.dup }.from([]).to([ context ])
    end
  end
end
