# encoding: utf-8

require 'spec_helper'
require 'veritas/relation_gateway'

describe RelationGateway, '#product' do
  subject { object.product(other) }

  let(:adapter)         { mock('Adapter')                        }
  let(:relation)        { mock('Relation')                       }
  let(:object)          { described_class.new(adapter, relation) }
  let(:operation)       { :product                               }
  let(:factory)         { Algebra::Product                       }
  let(:binary_relation) { mock(factory)                          }

  it_should_behave_like 'a binary relation method'
end
