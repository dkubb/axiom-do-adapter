# encoding: utf-8

require 'spec_helper'
require 'veritas/adapter/data_objects/statement'

describe Adapter::DataObjects::Statement, '#each' do
  let(:reader)     { mock('Reader', :next! => false).as_null_object            }
  let(:command)    { mock('Command', :execute_reader => reader).as_null_object }
  let(:connection) { mock('Connection', :create_command => command)            }
  let(:attribute)  { stub                                                      }
  let(:primitive)  { stub                                                      }
  let(:relation)   { mock('Relation', :header => [ attribute ])                }
  let(:generator)  { mock('Generator').as_null_object                          }
  let(:rows)       { [ stub, stub ]                                            }
  let(:object)     { described_class.new(connection, relation, generator)      }
  let(:yields)     { []                                                        }

  before do
    command.stub!(:dup => command, :freeze => command)
    attribute.stub_chain(:class, :primitive).and_return(primitive)
  end

  context 'with no block' do
    subject { object.each }

    it { should be_instance_of(to_enum.class) }

    it 'yields the expected attributes' do
      subject.to_a.should eql(object.to_a)
    end
  end

  context 'with a block' do
    subject { object.each { |row| yields << row } }

    before do
      connection.should_receive(:create_command).with(object.to_s)

      command.should_receive(:set_types).with([ primitive ]).ordered
      command.should_receive(:execute_reader).with(no_args).ordered

      rows.each do |values|
        reader.should_receive(:next!).with(no_args).ordered.and_return(true)
        reader.should_receive(:values).with(no_args).ordered.and_return(values)
      end

      reader.should_receive(:next!).with(no_args).ordered.and_return(false)
      reader.should_receive(:close).with(no_args).ordered
    end

    before do
      relation.should_receive(:header)
    end

    it_should_behave_like 'a command method'

    it 'yields each row' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to(rows)
    end
  end
end
