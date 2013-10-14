# encoding: utf-8

require 'spec_helper'
require 'axiom/adapter/data_objects/statement'

describe Adapter::DataObjects::Statement, '#each' do
  let(:reader)     { double('Reader', :next! => false).as_null_object            }
  let(:command)    { double('Command', :execute_reader => reader).as_null_object }
  let(:connection) { double('Connection', :create_command => command)            }
  let(:attribute)  { double                                                      }
  let(:primitive)  { double                                                      }
  let(:relation)   { double('Relation', :header => [ attribute ])                }
  let(:generator)  { double('Generator').as_null_object                          }
  let(:rows)       { [ double, double ]                                          }
  let(:object)     { described_class.new(connection, relation, generator)        }
  let(:yields)     { []                                                          }

  before do
    allow(command).to receive(:dup).and_return(command)
    allow(command).to receive(:freeze).and_return(command)
    attribute.stub_chain(:class, :primitive).and_return(primitive)
  end

  context 'with no block' do
    subject { object.each }

    it { should be_instance_of(to_enum.class) }

    it 'yields the expected attributes' do
      expect(subject.to_a).to eql(object.to_a)
    end
  end

  context 'with a block' do
    subject { object.each { |row| yields << row } }

    before do
      expect(connection).to receive(:create_command).with(object.to_s)

      expect(command).to receive(:set_types).with([ primitive ]).ordered
      expect(command).to receive(:execute_reader).with(no_args).ordered

      rows.each do |values|
        expect(reader).to receive(:next!).with(no_args).ordered.and_return(true)
        expect(reader).to receive(:values).with(no_args).ordered.and_return(values)
      end

      expect(reader).to receive(:next!).with(no_args).ordered.and_return(false)
      expect(reader).to receive(:close).with(no_args).ordered
    end

    before do
      expect(relation).to receive(:header)
    end

    it_should_behave_like 'a command method'

    it 'yields each row' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to(rows)
    end
  end
end
