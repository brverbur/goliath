#!/usr/bin/env ruby

$:<< '../lib' << 'lib'

require 'rubygems'

require 'goliath'
require 'goliath/plugins/latency'

require 'yajl'
# require 'json'

class Echo < Goliath::API

  # reload code on every request in dev environment
  use ::Rack::Reloader, 0 if Goliath.dev?

  use Goliath::Rack::Params             # parse & merge query and body parameters
  use Goliath::Rack::DefaultMimeType    # cleanup accepted media types
  use Goliath::Rack::Formatters::JSON   # JSON output formatter
  use Goliath::Rack::Render             # auto-negotiate response format
  use Goliath::Rack::Heartbeat          # respond to /status with 200, OK (monitoring, etc)
  use Goliath::Rack::ValidationError    # catch and render validation errors

  use Goliath::Rack::Validation::RequestMethod, %w(GET)           # allow GET requests only
  use Goliath::Rack::Validation::RequiredParam, {:key => 'echo'}  # must provide ?echo= query or body param

  plugin Goliath::Plugin::Latency       # output reactor latency every second

  def response(env)
    [200, {}, {response: env.params['echo']}]
  end
end