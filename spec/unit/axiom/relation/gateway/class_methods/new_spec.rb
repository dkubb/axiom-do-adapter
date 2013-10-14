# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '.new' do
  subject { object.new(adapter, relation) }

  let(:adapter)  { double          }
  let(:relation) { double          }
  let(:object)   { described_class }

  it { should be_instance_of(described_class) }

  it { should be_frozen }
end
