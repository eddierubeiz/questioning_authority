require 'spec_helper'

RSpec.describe Qa::LinkedData::LanguageService do
  describe '.preferred_language' do
    subject { described_class.preferred_language(user_language: user_language, authority_language: authority_language) }

    let(:user_language) { nil }
    let(:authority_language) { nil }

    context 'when neither user nor authority language are passed in' do
      it 'returns default language from Qa configuration' do
        expect(subject).to match_array [:en]
      end
    end

    context 'when authority language is passed in and user language is NOT passed in' do
      let(:authority_language) { :fr }

      it 'returns authority language' do
        expect(subject).to match_array [:fr]
      end
    end

    context 'when user and authority language are passed in' do
      let(:user_language) { :de }
      let(:authority_language) { :fr }

      it 'returns user language' do
        expect(subject).to match_array [:de]
      end
    end

    context 'when multiple languages' do
      let(:user_language) { [:de, :fr] }

      it 'returns multiple languages' do
        expect(subject).to match_array [:de, :fr]
      end
    end
  end

  describe '.literal_has_language_marker?' do
    subject { described_class.literal_has_language_marker? literal }

    context "when doesn't respond to language" do
      let(:literal) { RDF::Literal.new(123) }
      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context "when doesn't have language marker" do
      let(:literal) { RDF::Literal.new('String without language') }
      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context "when has language marker" do
      let(:literal) { RDF::Literal.new('String with language', language: :en) }
      it 'returns true' do
        expect(subject).to eq true
      end
    end
  end
end
