# encoding: utf-8

require 'spec_helper'
require 'axiom/adapter/data_objects'

describe Adapter::DataObjects, '#read' do
  let(:uri)       { double                   }
  let(:object)    { described_class.new(uri) }
  let(:relation)  { double('Relation')       }
  let(:statement) { double('Statement')      }
  let(:rows)      { [ [ 1 ], [ 2 ], [ 3 ] ]  }
  let(:yields)    { []                       }

  before do
    allow(statement).to receive(:each, &rows.method(:each))
    allow(described_class::Statement).to receive(:new).and_return(statement)
  end

  context 'with a block' do
    subject { object.read(relation) { |row| yields << row } }

    let(:connection) { double('Connection', :close => nil) }

    before do
      allow(DataObjects::Connection).to receive(:new).and_return(connection)
    end

    it_should_behave_like 'a command method'

    it 'opens a connection' do
      expect(DataObjects::Connection).to receive(:new).with(uri).and_return(connection)
      subject
    end

    it 'closes a connection' do
      expect(connection).to receive(:close).with(no_args)
      subject
    end

    it 'does not close a connection if the constructor throws an exception' do
      mock_exception = Class.new(Exception)
      expect(DataObjects::Connection).to receive(:new).and_raise(mock_exception)
      expect(connection).not_to receive(:close)
      expect { subject }.to raise_error(mock_exception)
    end

    it 'yields each row' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to(rows)
    end

    it 'initializes a statement' do
      expect(described_class::Statement).to receive(:new).with(connection, relation).and_return(statement)
      subject
    end
  end

  context 'without a block' do
    subject { object.read(relation) }

    it { should be_instance_of(to_enum.class) }
  end
end
