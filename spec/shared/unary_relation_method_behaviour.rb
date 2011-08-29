# encoding: utf-8

shared_examples_for 'a unary relation method' do
  let(:gateway) { mock('New Gateway') }

  before do
    described_class.stub!(:new).and_return(gateway)
  end

  it { should equal(gateway) }

  it 'tests the response is a relation' do
    response.should_receive(:kind_of?).with(Relation)
    subject
  end

  it 'initializes the new gateway with the adapter' do
    described_class.should_receive(:new).with(adapter, anything)
    subject
  end

  it 'initializes the new gateway with the response' do
    described_class.should_receive(:new).with(anything, response)
    subject
  end
end
