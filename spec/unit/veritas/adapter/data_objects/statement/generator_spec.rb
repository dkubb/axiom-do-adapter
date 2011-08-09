# encoding: utf-8

require 'spec_helper'

describe Adapter::DataObjects::Statement, '#generator' do
  subject { object.generator }

  let(:connection) { stub }
  let(:relation)   { stub }

  context 'when a generator' do
    let(:generator) { mock('Generator')                                    }
    let(:object)    { described_class.new(connection, relation, generator) }

    it_should_behave_like 'an idempotent method'

    it { should equal(generator) }
  end

  context 'when no generator' do
    let(:object) { described_class.new(connection, relation) }

    it_should_behave_like 'an idempotent method'

    it { should equal(SQL::Generator::Relation) }
  end
end
