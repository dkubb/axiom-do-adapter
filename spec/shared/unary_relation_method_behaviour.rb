# encoding: utf-8

shared_examples_for 'a unary relation method' do
  let(:gateway) { double('New Gateway') }

  before do
    allow(described_class).to receive(:new).and_return(gateway)
  end

  it { should equal(gateway) }

  it 'tests the response is a relation' do
    expect(response).to receive(:kind_of?).with(Relation)
    subject
  end

  it 'initializes the new gateway with the adapter and response' do
    expect(described_class).to receive(:new).with(adapter, response)
    subject
  end
end
