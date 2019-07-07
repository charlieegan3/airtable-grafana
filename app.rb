require "active_support/all"
require "sinatra"
require "airtable"
require "json"

set :bind, '0.0.0.0'

def load_timeseries(table_name, from, to)
  airtable = Airtable::Client.new(ENV.fetch("AIRTABLE_KEY"))
  table = airtable.table(ENV.fetch("AIRTABLE_BASE"), table_name)

  after = "IS_AFTER({timestamp}, DATETIME_PARSE('#{from}', 'YYYY-MM-DDTHH:mm:ss'))"
  before = "IS_BEFORE({timestamp}, DATETIME_PARSE('#{to}', 'YYYY-MM-DDTHH:mm:ss'))"
  formula = "AND(#{after}, #{before})"

  targets = Hash.new([])
  datapoints = table.select(sort: ["timestamp", :asc], formula: formula).map do |record|
    record[:labels].each do |l|
      targets[l] += [[record[:value], Time.parse(record["timestamp"]).to_i*1000]]
    end
  end

  targets.map { |k, v| { target:  k, datapoints: v } }
end

get "/" do
  "ok"
end

post "/search" do
  JSON.generate(ENV.fetch("AIRTABLE_TABLES").split(","))
end

post "/query" do
  request.body.rewind
  request_payload = JSON.parse(request.body.read)

  target = request_payload["targets"].first["target"]
  from = request_payload["range"]["from"]
  to = request_payload["range"]["to"]

  JSON.generate(load_timeseries(target, from, to))
end
