# encoding: utf-8

shared_examples_for 'a binary relation method' do
  describe 'when other has the same adapter' do
    let(:other_relation) { mock('Other Relation')                       }
    let(:other)          { described_class.new(adapter, other_relation) }
    let(:gateway)        { mock('Other Gateway')                        }

    before do
      relation.stub!(operation).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'passes the other relation to the binary operation' do
      relation.should_receive(operation).with(other_relation)
      subject
    end
  end

  describe 'when other has a different adapter' do
    let(:other_adapter) { mock('Other Adapter')                    }
    let(:other)         { described_class.new(other_adapter, stub) }

    before do
      factory.stub!(:new).and_return(binary_relation)
    end

    it { should equal(binary_relation) }

    it 'initializes the binary operation with the gateways' do
      factory.should_receive(:new).with(object, other)
      subject
    end
  end

  describe 'when other has no adapter' do
    let(:other) { mock('Other Relation') }

    before do
      factory.stub!(:new).and_return(binary_relation)
    end

    it { should equal(binary_relation) }

    it 'initializes the binary operation with the gateway and other relation' do
      factory.should_receive(:new).with(object, other)
      subject
    end
  end
end
