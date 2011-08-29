# encoding: utf-8

require 'spec_helper'
require 'veritas/adapter/data_objects'

describe Adapter::DataObjects, '.new' do
  subject { object.new(uri) }

  let(:uri)    { stub            }
  let(:object) { described_class }

  it { should be_instance_of(described_class) }

  it { should be_frozen }
end
