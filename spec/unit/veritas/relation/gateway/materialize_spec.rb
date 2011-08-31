# encoding: utf-8

require 'spec_helper'
require 'veritas/relation/gateway'

describe Relation::Gateway, '#materialize' do
  subject { object.materialize }

  let(:header)       { mock('Header')                                                                          }
  let(:directions)   { mock('Directions')                                                                      }
  let(:adapter)      { stub.as_null_object                                                                     }
  let(:relation)     { mock('Relation', :header => header, :directions => directions, :materialized? => false) }
  let!(:object)      { described_class.new(adapter, relation)                                                  }
  let(:materialized) { mock('Materialized')                                                                    }

  before do
    Relation.stub!(:new).and_return(stub.as_null_object)
    Relation::Materialized.stub!(:new).and_return(materialized)
  end

  it { should equal(materialized) }

  it 'initializes the materialized relation with the header, tuples and directions' do
    Relation::Materialized.should_receive(:new).with(header, [], directions)
    subject
  end
end
