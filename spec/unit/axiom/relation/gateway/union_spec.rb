# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#union' do
  subject { object.union(other) }

  let(:adapter)         { double('Adapter')                      }
  let(:relation)        { double('Relation')                     }
  let(:object)          { described_class.new(adapter, relation) }
  let(:operation)       { :union                                 }
  let(:factory)         { Algebra::Union                         }
  let(:binary_relation) { double(factory)                        }

  it_should_behave_like 'a binary relation method'
end
