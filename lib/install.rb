# frozen_string_literal: true

class Install
  DEFAULT_DEPENDENCIES = {
    "rubocop" => "latest"
  }.freeze

  attr_reader :config

  def initialize(config)
    @config = Hash(config)
  end

  def run
    gemfile = config.fetch("gemfile", "Gemfile")
    return system("bundle install --gemfile=#{gemfile}") if config.fetch("bundle", false)

    system("gem install #{dependencies} --no-document")
  end

  private

  def dependencies
    DEFAULT_DEPENDENCIES.merge(custom_dependencies).map(&method(:version_string)).join(" ")
  end

  def custom_dependencies
    Hash[config.fetch("versions", []).map(&method(:version))]
  end

  def version(dependency)
    case dependency
    when Hash
      dependency.first
    else
      [dependency, "latest"]
    end
  end

  def version_string(dependency, version)
    version == "latest" ? dependency : "#{dependency}:#{version}"
  end
end
