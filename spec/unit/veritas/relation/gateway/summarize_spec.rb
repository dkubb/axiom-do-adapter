# encoding: utf-8

require 'spec_helper'
require 'veritas/relation/gateway'

describe Relation::Gateway, '#summarize' do
  let(:summarization) { mock('Summarization', :kind_of? => true)      }
  let(:adapter)       { mock('Adapter')                               }
  let(:relation)      { mock('Relation', :summarize => summarization) }
  let!(:object)       { described_class.new(adapter, relation)        }
  let(:block)         { lambda { |context| }                          }

  context 'with no arguments' do
    subject { object.summarize(&block) }

    let(:gateway) { mock('New Gateway') }

    before do
      described_class.stub!(:new).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'forwards the default summarize_with relation to relation#summarize' do
      relation.should_receive(:summarize) do |other|
        other.should equal(TABLE_DEE)
      end
      subject
    end

    it 'forwards the block to relation#summarize' do
      relation.stub!(:summarize) do |_summarize_with, proc|
        proc.should equal(block)
      end
      subject
    end

    it 'initializes the gateway with the adapter and summarization' do
      described_class.should_receive(:new).with(adapter, summarization)
      subject
    end
  end

  context 'with a header' do
    subject { object.summarize(header, &block) }

    let(:gateway) { mock('New Gateway') }
    let(:header)  { mock('Header')      }

    before do
      described_class.stub!(:new).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'forwards the header to relation#summarize' do
      relation.should_receive(:summarize) do |other|
        other.should equal(header)
      end
      subject
    end

    it 'forwards the block to relation#summarize' do
      relation.stub!(:summarize) do |_summarize_with, proc|
        proc.should equal(block)
      end
      subject
    end

    it 'initializes the gateway with the adapter and summarization' do
      described_class.should_receive(:new).with(adapter, summarization)
      subject
    end
  end

  context 'when summarize_with has the same adapter' do
    subject { object.summarize(other, &block) }

    let(:header)         { mock('Header')                               }
    let(:other_relation) { mock('Other Relation', :header => header)    }
    let!(:other)         { described_class.new(adapter, other_relation) }
    let(:gateway)        { mock('New Gateway')                          }

    before do
      described_class.stub!(:new).and_return(gateway)
    end

    it { should equal(gateway) }

    it 'forwards the other relation to relation#summarize' do
      relation.should_receive(:summarize) do |other|
        other.should equal(other_relation)
      end
      subject
    end

    it 'forwards the block to relation#summarize' do
      relation.stub!(:summarize) do |_summarize_with, proc|
        proc.should equal(block)
      end
      subject
    end

    it 'initializes the gateway with the adapter and summarization' do
      described_class.should_receive(:new).with(adapter, summarization)
      subject
    end
  end

  context 'with a relation' do
    subject { object.summarize(summarize_with, &block) }

    let(:context_header)   { mock('Context Header')                              }
    let(:header)           { mock('Header', :- => context_header)                }
    let(:summarize_header) { mock('Summarize With Header')                       }
    let(:summarize_with)   { mock('Other Relation', :header => summarize_header) }
    let(:functions)        { mock('Functions')                                   }
    let(:context)          { mock('Context', :functions => functions)            }

    before do
      relation.stub!(:header).and_return(header)
      Algebra::Summarization.stub!(:new).and_return(summarization)
      Evaluator::Context.stub!(:new).and_return(context)
    end

    it { should equal(summarization) }

    it 'gets the context header' do
      header.should_receive(:-).with(summarize_header)
      subject
    end

    it 'passes the context header into the context' do
      Evaluator::Context.should_receive(:new).with(context_header)
      subject
    end

    it 'forwards the block to the context' do
      Evaluator::Context.stub!(:new) { |_header, proc| proc.should equal(block) }.and_return(context)
      subject
    end

    it 'initializes the summarization with the gateway, the relation and the functions' do
      Algebra::Summarization.should_receive(:new).with(object, summarize_with, functions)
      subject
    end
  end
end
