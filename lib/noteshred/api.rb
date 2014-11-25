require 'rest-client'
require 'json'

module Noteshred
  module Api
    RestClient.add_before_execution_proc do |req, params|
      raise ArgumentError.new('Missing NoteShred API Key') if Noteshred.api_key.nil?
    end

    def self.get(rel,params = nil)
      response = RestClient.get(Noteshred.url(rel), {:params => params, :authorization => "Token token=#{Noteshred.api_key}"}){|response, request, result| response }
      Noteshred::Api.render(response)
    end

    def self.post(rel,params = nil)
      response = RestClient.post(Noteshred.url(rel), params, {:authorization => "Token token=#{Noteshred.api_key}", :content_type => :json, :accept => :json}){|response, request, result| response }
      Noteshred::Api.render(response)
    end

    def self.render(response)
      JSON.parse(response)
    rescue JSON::ParserError => err
      {:error => err.message}
    rescue StandardError
      {:error => 'Error parsing response'}
    end
  end
end
