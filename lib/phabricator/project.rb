require_relative './conduit_client'

module Phabricator
  class Project
    @@cached_projects = {}

    attr_reader :id, :phid
    attr_accessor :name

    def self.populate_all
      response = JSON.parse(client.request(:post, 'project.query'))

      response['result'].each do |phid, data|
        project = Project.new(data)
        @@cached_projects[project.name] = project
      end
    end

    def self.find_by_name(name)
      populate_all if @@cached_projects.empty?

      @@cached_projects[name]
    end

    def initialize(attributes)
      @id = attributes['id']
      @phid = attributes['phid']
      @name = attributes['name']
    end

    private

    def self.client
      @client ||= Phabricator::ConduitClient.instance
    end
  end
end
