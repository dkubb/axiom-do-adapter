# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#materialize' do
  subject { object.materialize }

  let(:header)       { double('Header')                                                                          }
  let(:directions)   { double('Directions')                                                                      }
  let(:adapter)      { double.as_null_object                                                                     }
  let(:relation)     { double('Relation', :header => header, :directions => directions, :materialized? => false) }
  let!(:object)      { described_class.new(adapter, relation)                                                    }
  let(:materialized) { double('Materialized')                                                                    }

  before do
    allow(Relation::Materialized).to receive(:new).and_return(materialized)
    allow(Relation).to receive(:new).and_return(double.as_null_object)
  end

  it { should equal(materialized) }

  it 'initializes the materialized relation with the header, tuples and directions' do
    expect(Relation::Materialized).to receive(:new).with(header, [], directions)
    subject
  end
end
