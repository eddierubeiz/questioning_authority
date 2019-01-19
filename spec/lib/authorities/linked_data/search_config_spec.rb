require 'spec_helper'

RSpec.describe Qa::Authorities::LinkedData::SearchConfig do
  let(:full_config) { Qa::Authorities::LinkedData::Config.new(:LOD_FULL_CONFIG).search }
  let(:min_config) { Qa::Authorities::LinkedData::Config.new(:LOD_MIN_CONFIG).search }
  let(:term_only_config) { Qa::Authorities::LinkedData::Config.new(:LOD_TERM_ONLY_CONFIG).search }
  let(:encoding_config) { Qa::Authorities::LinkedData::Config.new(:LOD_ENCODING_CONFIG).search }

  describe '#search_config' do
    let(:full_search_config) do
      {
        url: {
          :@context => 'http://www.w3.org/ns/hydra/context.jsonld',
          :@type => 'IriTemplate',
          template: 'http://localhost/test_default/search?subauth={?subauth}&query={?query}&param1={?param1}&param2={?param2}',
          variableRepresentation: 'BasicRepresentation',
          mapping: [
            {
              :@type => 'IriTemplateMapping',
              variable: 'query',
              property: 'hydra:freetextQuery',
              required: true
            },
            {
              :@type => 'IriTemplateMapping',
              variable: 'subauth',
              property: 'hydra:freetextQuery',
              required: false,
              default: 'search_sub1_name'
            },
            {
              :@type => 'IriTemplateMapping',
              variable: 'param1',
              property: 'hydra:freetextQuery',
              required: false,
              default: 'delta'
            },
            {
              :@type => 'IriTemplateMapping',
              variable: 'param2',
              property: 'hydra:freetextQuery',
              required: false,
              default: 'echo'
            }
          ]
        },
        qa_replacement_patterns: {
          query: 'query',
          subauth: 'subauth'
        },
        language: ['en', 'fr', 'de'],
        results: {
          id_predicate: 'http://purl.org/dc/terms/identifier',
          label_predicate: 'http://www.w3.org/2004/02/skos/core#prefLabel',
          altlabel_predicate: 'http://www.w3.org/2004/02/skos/core#altLabel',
          sort_predicate: 'http://www.w3.org/2004/02/skos/core#prefLabel'
        },
        context: {
          groups: {
            dates: {
              group_label_i18n: "qa.linked_data.authority.locnames_ld4l_cache.dates",
              group_label_default: "Dates"
            }
          },
          properties: [
            {
              property_label_i18n: "qa.linked_data.authority.locgenres_ld4l_cache.authoritative_label",
              property_label_default: "Authoritative Label",
              lpath: "madsrdf:authoritativeLabel",
              selectable: true,
              drillable: false
            },
            {
              group_id: "dates",
              property_label_i18n: "qa.linked_data.authority.locnames_ld4l_cache.birth_date",
              property_label_default: "Birth",
              lpath: "madsrdf:identifiesRWO/madsrdf:birthDate/schema:label",
              selectable: false,
              drillable: false
            }
          ]
        },
        subauthorities: {
          search_sub1_key: 'search_sub1_name',
          search_sub2_key: 'search_sub2_name',
          search_sub3_key: 'search_sub3_name'
        }
      }
    end

    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.send(:search_config)).to be_empty
    end
    it 'returns hash of search configuration' do
      expect(full_config.send(:search_config)).to eq full_search_config
    end
  end

  describe '#supports_search?' do
    it 'returns false if search is NOT configured' do
      expect(term_only_config.supports_search?).to eq false
    end
    it 'returns true if search is configured' do
      expect(full_config.supports_search?).to eq true
    end
  end

  describe '#url_config' do
    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.url_config).to eq nil
    end
    it 'returns the url config from the configuration' do
      expect(full_config.url_config).to be_kind_of Qa::IriTemplate::UrlConfig
    end
  end

  describe '#language' do
    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.language).to eq nil
    end
    it 'returns nil if language is not specified' do
      expect(min_config.language).to eq nil
    end
    it 'returns the preferred language for selecting literal values if configured for search' do
      expect(full_config.language).to eq [:en, :fr, :de]
    end
  end

  describe '#results' do
    let(:results_config) do
      {
        id_predicate: 'http://purl.org/dc/terms/identifier',
        label_predicate: 'http://www.w3.org/2004/02/skos/core#prefLabel',
        altlabel_predicate: 'http://www.w3.org/2004/02/skos/core#altLabel',
        sort_predicate: 'http://www.w3.org/2004/02/skos/core#prefLabel'
      }
    end

    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.results).to eq nil
    end
    it 'returns hash of predicates' do
      expect(full_config.results).to eq results_config
    end
  end

  describe '#results_id_predicate' do
    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.results_id_predicate).to eq nil
    end
    it 'returns the predicate that holds the ID in search results' do
      expect(full_config.results_id_predicate).to eq RDF::URI('http://purl.org/dc/terms/identifier')
    end
  end

  describe '#results_label_predicate' do
    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.results_label_predicate).to eq nil
    end
    it 'returns the predicate that holds the label in search results' do
      expect(full_config.results_label_predicate).to eq RDF::URI('http://www.w3.org/2004/02/skos/core#prefLabel')
    end
  end

  describe '#results_altlabel_predicate' do
    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.results_altlabel_predicate).to eq nil
    end
    it 'return nil if altlabel predicate is not defined' do
      expect(min_config.results_altlabel_predicate).to eq nil
    end
    it 'returns the predicate that holds the altlabel in search results' do
      expect(full_config.results_altlabel_predicate).to eq RDF::URI('http://www.w3.org/2004/02/skos/core#altLabel')
    end
  end

  describe '#supports_sort?' do
    it 'returns false if only term configuration is defined' do
      expect(term_only_config.supports_sort?).to eq false
    end
    it 'returns false if sort predicate is NOT defined' do
      expect(min_config.supports_sort?).to eq false
    end
    it 'returns true if sort predicate IS defined' do
      expect(full_config.supports_sort?).to eq true
    end
  end

  describe '#results_sort_predicate' do
    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.results_sort_predicate).to eq nil
    end
    it 'returns nil if sort predicate is not defined' do
      expect(min_config.results_sort_predicate).to eq nil
    end
    it 'returns the predicate on which results should be sorted' do
      expect(full_config.results_sort_predicate).to eq RDF::URI('http://www.w3.org/2004/02/skos/core#prefLabel')
    end
  end

  describe '#supports_context?' do
    it 'returns false if only term configuration is defined' do
      expect(term_only_config.supports_context?).to eq false
    end
    it 'returns false if NOT defined in the configuration' do
      expect(min_config.supports_context?).to eq false
    end
    it 'returns true if defined in the configuration' do
      expect(full_config.supports_context?).to eq true
    end
  end

  describe '#context_map' do
    it 'returns nil if only term configuration is defined' do
      expect(term_only_config.context_map).to eq nil
    end
    it 'returns nil if NOT defined in the configuration' do
      expect(min_config.context_map).to eq nil
    end
    it 'returns the context map if defined in the configuration' do
      expect(full_config.context_map).to be_kind_of Qa::LinkedData::Config::ContextMap
    end
  end

  describe '#subauthorities?' do
    it 'returns false if only term configuration is defined' do
      expect(term_only_config.subauthorities?).to eq false
    end
    it 'returns false if the configuration does NOT define subauthorities' do
      expect(min_config.subauthorities?).to eq false
    end
    it 'returns true if the configuration defines subauthorities' do
      expect(full_config.subauthorities?).to eq true
    end
  end

  describe '#subauthority?' do
    it 'returns false if only term configuration is defined' do
      expect(term_only_config.subauthority?('fake_subauth')).to eq false
    end
    it 'returns false if there are no subauthorities configured' do
      expect(min_config.subauthority?('fake_subauth')).to eq false
    end
    it 'returns false if the requested subauthority is NOT configured' do
      expect(full_config.subauthority?('fake_subauth')).to eq false
    end
    it 'returns true if the requested subauthority is configured' do
      expect(full_config.subauthority?('search_sub2_key')).to eq true
    end
  end

  describe '#subauthority_count' do
    it 'returns 0 if only term configuration is defined' do
      expect(term_only_config.subauthority_count).to eq 0
    end
    it 'returns 0 if the configuration does NOT define subauthorities' do
      expect(min_config.subauthority_count).to eq 0
    end
    it 'returns the number of subauthorities if defined' do
      expect(full_config.subauthority_count).to eq 3
    end
  end

  describe '#subauthorities' do
    it 'returns empty hash if only term configuration is defined' do
      empty_hash = {}
      expect(term_only_config.subauthorities).to eq empty_hash
    end
    it 'returns empty hash if no subauthorities are defined' do
      empty_hash = {}
      expect(min_config.subauthorities).to eq empty_hash
    end
    it 'returns hash of all subauthority key-value patterns defined' do
      expected_hash = {
        search_sub1_key: 'search_sub1_name',
        search_sub2_key: 'search_sub2_name',
        search_sub3_key: 'search_sub3_name'
      }
      expect(full_config.subauthorities).to eq expected_hash
    end
  end
end
