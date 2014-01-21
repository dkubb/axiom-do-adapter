# encoding: utf-8

require 'spec_helper'
require 'axiom/relation/gateway'

describe Relation::Gateway, '#summarize' do
  let(:summarization) { double('Summarization', :kind_of? => true)   }
  let(:adapter)       { double('Adapter')                            }
  let(:relation)      { double('Relation', summarize: summarization) }
  let!(:object)       { described_class.new(adapter, relation)       }
  let(:block)         { ->(context) {}                               }

  context 'with no arguments' do
    subject { object.summarize(&block) }

    let(:gateway) { double('New Gateway') }

    before do
      allow(described_class).to receive(:new).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'forwards the default summarize_with relation to relation#summarize' do
      expect(relation).to receive(:summarize) do |other|
        expect(other).to equal(TABLE_DEE)
      end
      subject
    end

    it 'forwards the block to relation#summarize' do
      expect(relation).to receive(:summarize) do |_summarize_with, &proc|
        expect(proc).to equal(block)
      end
      subject
    end

    it 'initializes the gateway with the adapter and summarization' do
      expect(described_class).to receive(:new).with(adapter, summarization)
      subject
    end
  end

  context 'with a header' do
    subject { object.summarize(header, &block) }

    let(:gateway) { double('New Gateway') }
    let(:header)  { double('Header')      }

    before do
      allow(described_class).to receive(:new).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'forwards the header to relation#summarize' do
      expect(relation).to receive(:summarize) do |other|
        expect(other).to equal(header)
      end
      subject
    end

    it 'forwards the block to relation#summarize' do
      expect(relation).to receive(:summarize) do |_summarize_with, &proc|
        expect(proc).to equal(block)
      end
      subject
    end

    it 'initializes the gateway with the adapter and summarization' do
      expect(described_class).to receive(:new).with(adapter, summarization)
      subject
    end
  end

  context 'when summarize_with has the same adapter' do
    subject { object.summarize(other, &block) }

    let(:header)         { double('Header')                             }
    let(:other_relation) { double('Other Relation', header: header)     }
    let!(:other)         { described_class.new(adapter, other_relation) }
    let(:gateway)        { double('New Gateway')                        }

    before do
      allow(described_class).to receive(:new).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'forwards the other relation to relation#summarize' do
      expect(relation).to receive(:summarize) do |other|
        expect(other).to equal(other_relation)
      end
      subject
    end

    it 'forwards the block to relation#summarize' do
      expect(relation).to receive(:summarize) do |&proc|
        expect(proc).to equal(block)
      end
      subject
    end

    it 'initializes the gateway with the adapter and summarization' do
      expect(described_class).to receive(:new).with(adapter, summarization)
      subject
    end
  end

  context 'with a relation' do
    subject { object.summarize(summarize_with, &block) }

    let(:context_header)   { double('Context Header')                           }
    let(:header)           { double('Header', :- => context_header)             }
    let(:summarize_header) { double('Summarize With Header')                    }
    let(:summarize_with)   { double('Other Relation', header: summarize_header) }
    let(:functions)        { double('Functions')                                }
    let(:context)          { double('Context', functions: functions)            }

    before do
      allow(relation).to receive(:header).and_return(header)
      allow(Algebra::Summarization).to receive(:new).and_return(summarization)
      allow(Evaluator::Context).to receive(:new).and_return(context)
    end

    it { should equal(summarization) }

    it 'gets the context header' do
      expect(header).to receive(:-).with(summarize_header)
      subject
    end

    it 'passes the context header into the context' do
      expect(Evaluator::Context).to receive(:new).with(context_header)
      subject
    end

    it 'forwards the block to the context' do
      allow(Evaluator::Context).to receive(:new) { |&proc| expect(proc).to equal(block) }.and_return(context)
      subject
    end

    it 'initializes the summarization with the gateway, the relation and the functions' do
      expect(Algebra::Summarization).to receive(:new).with(object, summarize_with, functions)
      subject
    end
  end
end
