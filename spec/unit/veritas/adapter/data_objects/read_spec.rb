# encoding: utf-8

require 'spec_helper'
require 'veritas/adapter/data_objects'

shared_examples_for 'it uses the data_objects driver' do
  let(:connection) { mock('Connection', :close => nil) }

  before do
    DataObjects::Connection.stub!(:new).and_return(connection)
  end

  it 'opens a connection' do
    DataObjects::Connection.should_receive(:new).with(uri).and_return(connection)
    subject
  end

  it 'closes a connection' do
    connection.should_receive(:close).with(no_args)
    subject
  end

  it 'does not close a connection if the constructor throws an exception' do
    mock_exception = Class.new(Exception)
    DataObjects::Connection.should_receive(:new).and_raise(mock_exception)
    connection.should_not_receive(:close)
    expect { subject }.to raise_error(mock_exception)
  end
end

describe Adapter::DataObjects, '#read' do
  subject { object.read(relation) { |row| yields << row } }

  let(:uri)       { stub                     }
  let(:object)    { described_class.new(uri) }
  let(:relation)  { mock('Relation')         }
  let(:statement) { mock('Statement')        }
  let(:rows)      { [ [ 1 ], [ 2 ], [ 3 ] ]  }
  let(:yields)    { []                       }

  before do
    expectation = statement.stub(:each)
    rows.each { |row| expectation.and_yield(row) }

    described_class::Statement.stub!(:new).and_return(statement)
  end

  it_should_behave_like 'it uses the data_objects driver'
  it_should_behave_like 'a command method'

  it 'yields each row' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to(rows)
  end

  it 'initializes a statement' do
    described_class::Statement.should_receive(:new).with(connection, relation).and_return(statement)
    subject
  end
end
