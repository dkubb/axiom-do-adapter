# encoding: utf-8

require 'spec_helper'
require 'veritas/relation/gateway'

describe Relation::Gateway, '#respond_to?' do
  subject { object.respond_to?(method) }

  let(:relation) { mock('Relation', :header => stub)   }
  let(:object)   { described_class.new(stub, relation) }

  context 'with an unknown method' do
    let(:method) { :unknown }

    it { should be(false) }
  end

  context 'with a known method' do
    let(:method) { :each }

    it { should be(true) }
  end

  context 'with a known method in the relation' do
    let(:method) { :header }

    it { should be(true) }
  end
end
