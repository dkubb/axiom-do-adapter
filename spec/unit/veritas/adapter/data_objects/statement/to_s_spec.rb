# encoding: utf-8

require 'spec_helper'
require 'veritas/adapter/data_objects/statement'

describe Adapter::DataObjects::Statement, '#to_s' do
  subject { object.to_s }

  let(:sql)        { mock('SQL')                                          }
  let(:connection) { stub                                                 }
  let(:relation)   { mock('Relation')                                     }
  let(:generator)  { mock('Generator', :to_sql => sql).as_null_object     }
  let(:object)     { described_class.new(connection, relation, generator) }

  it_should_behave_like 'an idempotent method'

  it { should be_frozen }

  it { should equal(sql) }

  it 'visits the relation' do
    generator.should_receive(:visit).with(relation).and_return(generator)
    subject
  end
end
