# encoding: utf-8

shared_examples_for 'a binary relation method' do
  describe 'when other has the same adapter' do
    let(:other_relation) { double('Other Relation')                     }
    let(:other)          { described_class.new(adapter, other_relation) }
    let(:gateway)        { double('Other Gateway')                      }

    before do
      allow(relation).to receive(operation).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'passes the other relation to the binary operation' do
      expect(relation).to receive(operation).with(other_relation)
      subject
    end
  end

  describe 'when other has a different adapter' do
    let(:other_adapter) { double('Other Adapter')                    }
    let(:other)         { described_class.new(other_adapter, double) }

    before do
      allow(factory).to receive(:new).and_return(binary_relation)
    end

    it { should equal(binary_relation) }

    it 'initializes the binary operation with the gateways' do
      expect(factory).to receive(:new).with(object, other)
      subject
    end
  end

  describe 'when other has no adapter' do
    let(:other) { double('Other Relation') }

    before do
      allow(factory).to receive(:new).and_return(binary_relation)
    end

    it { should equal(binary_relation) }

    it 'initializes the binary operation with the gateway and other relation' do
      expect(factory).to receive(:new).with(object, other)
      subject
    end
  end
end
