# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#respond_to?' do
  subject { object.respond_to?(method) }

  let(:relation) { double('Relation', :header => double) }
  let(:object)   { described_class.new(double, relation) }

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
