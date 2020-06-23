# frozen_string_literal: true

require 'csv'

module Tasks
  class ImportData
    def initialize(filename)
      @filename = filename
    end

    attr_reader :filename, :file, :csv

    def call
      begin
        @file = File.read(filename)
      rescue StandardError
        puts "No file \"#{filename}\" found"
        return
      end
      load_csv

      created, failed = create_records

      puts "Created records indexes: #{created}"
      puts "Failed records indexes: #{failed}"
    end

    def create_records
      created = []
      failed = []

      csv.each_with_index do |row, index|
        if create_record(row)
          created << index
        else
          failed << index
        end
      end

      [created, failed]
    end

    def load_csv
      @csv = CSV.parse(file, headers: true)
    end

    def create_record(row)
      resource = Resource.create(name: row[0],
                                 description: row[1],
                                 location: [row[2], row[3]].compact.join(', '),
                                 target_url: row[4],
                                 organizer: row[6],
                                 contact: row[7],
                                 how_to_help: row[8],
                                 category: 'for_hospitals')
      result(resource, row)
    end

    def result(resource, row)
      if resource.persisted?
        puts "Created resource with name #{row[0]}"
        true
      else
        puts "Could not create resource with name #{row[0]}"
        false
      end
    end
  end
end
