# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes do


  describe '#content' do
    let(:config) { Firstclasspostcodes::Configuration.new }

    it 'defaults to json' do
      expect(Firstclasspostcodes::Configuration.default.content).to eq('json')
      expect(config.content).to eq('json')
    end

    # it 'raises when an invalid type is passed' do
    #   expect { config.content = "awdgfde" }.to raise_error(StandardError)
    # end
  end

  describe '#configure' do
    it 'calls a configuration block' do
      expect { |b| Firstclasspostcodes.configure(&b) }.to yield_control
    end
  end

  describe '#protocol' do
    it 'removes :// from the protocol' do
      Firstclasspostcodes.configure { |c| c.protocol = 'https://' }
      expect(Firstclasspostcodes::Configuration.default.protocol).to eq('https')
    end
  end

  describe '#host' do
    it 'removes http from host' do
      Firstclasspostcodes.configure { |c| c.host = 'http://example.com' }
      expect(Firstclasspostcodes::Configuration.default.host).to eq('example.com')
    end

    it 'removes https from host' do
      Firstclasspostcodes.configure { |c| c.host = 'https://wookiee.com' }
      expect(Firstclasspostcodes::Configuration.default.host).to eq('wookiee.com')
    end

    it 'removes trailing path from host' do
      Firstclasspostcodes.configure { |c| c.host = 'hobo.com/v4' }
      expect(Firstclasspostcodes::Configuration.default.host).to eq('hobo.com')
    end
  end

  describe '#base_path' do
    it "prepends a slash to base_path" do
      Firstclasspostcodes.configure { |c| c.base_path = 'v4/dog' }
      expect(Firstclasspostcodes::Configuration.default.base_path).to eq('/v4/dog')
    end

    it "doesn't prepend a slash if one is already there" do
      Firstclasspostcodes.configure { |c| c.base_path = '/v4/dog' }
      expect(Firstclasspostcodes::Configuration.default.base_path).to eq('/v4/dog')
    end

    it "ends up as a blank string if nil" do
      Firstclasspostcodes.configure { |c| c.base_path = nil }
      expect(Firstclasspostcodes::Configuration.default.base_path).to eq('')
    end
  end

  describe '#geo_json?' do
    let(:config) { Firstclasspostcodes::Configuration.new }

    it 'defaults to false' do
      expect(Firstclasspostcodes::Configuration.default.geo_json?).to be_falsey
      expect(config.geo_json?).to be_falsey
    end

    it 'can be customized' do
      config.content = 'geo+json'
      expect(config.geo_json?).to be_truthy
    end
  end

  describe '#debug?' do
    let(:config) { Firstclasspostcodes::Configuration.new }

    it 'defaults to false' do
      expect(Firstclasspostcodes::Configuration.default.debug?).to be_falsey
      expect(config.debug?).to be_falsey
    end

    it 'can be customized' do
      config.debug = true
      expect(config.debug?).to be_truthy
    end
  end

  describe 'timeout in #build_request' do
    let(:config) { Firstclasspostcodes::Configuration.new }

    it 'defaults to 0' do
      expect(Firstclasspostcodes::Configuration.default.timeout).to eq(0)
      expect(config.timeout).to eq(0)
      expect(config.to_request_params[:timeout]).to eq(0)
    end

    it 'can be customized' do
      config.timeout = 100
      expect(config.to_request_params[:timeout]).to eq(100)
    end
  end
end