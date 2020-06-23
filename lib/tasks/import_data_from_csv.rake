# frozen_string_literal: true

namespace :quarantine_helper do
  desc 'Import data from CSV file.'
  task import_data_from_csv: :environment do
    Tasks::ImportData.new('data.csv').call
  end
end
