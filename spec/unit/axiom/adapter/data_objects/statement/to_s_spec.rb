# encoding: utf-8

require 'spec_helper'
require 'axiom/adapter/data_objects/statement'

describe Adapter::DataObjects::Statement, '#to_s' do
  subject { object.to_s }

  let(:sql)        { double('SQL')                       }
  let(:connection) { double                              }
  let(:relation)   { double('Relation')                  }
  let(:generator)  { double('Generator', :to_sql => sql) }

  context 'without a visitor' do
    let(:visitor) { SQL::Generator::Relation                  }  # default visitor
    let(:object)  { described_class.new(connection, relation) }

    before do
      allow(visitor).to receive(:visit).and_return(generator)
    end

    it_should_behave_like 'an idempotent method'

    it { should be_frozen }

    it { should equal(sql) }

    it 'visits the relation' do
      expect(visitor).to receive(:visit).with(relation)
      subject
    end
  end

  context 'with a visitor' do
    let(:visitor) { double('Visitor', :visit => generator)             }
    let(:object)  { described_class.new(connection, relation, visitor) }

    before do
      allow(visitor).to receive(:visit).and_return(generator)
    end

    it_should_behave_like 'an idempotent method'

    it { should be_frozen }

    it { should equal(sql) }

    it 'visits the relation' do
      expect(visitor).to receive(:visit).with(relation)
      subject
    end
  end
end
