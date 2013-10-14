# encoding: utf-8

require 'spec_helper'
require 'axiom/adapter/data_objects/statement'

describe Adapter::DataObjects::Statement, '.new' do
  let(:connection) { double          }
  let(:relation)   { double          }
  let(:object)     { described_class }

  context 'without a visitor' do
    subject { object.new(connection, relation) }

    it { should be_instance_of(described_class) }

    it { should be_frozen }
  end

  context 'with a visitor' do
    subject { object.new(connection, relation, visitor) }

    let(:visitor) { double }

    it { should be_instance_of(described_class) }

    it { should be_frozen }
  end
end
