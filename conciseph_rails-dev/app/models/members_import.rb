# frozen_string_literal: true

class MembersImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path, csv_options: { encoding: 'iso-8859-1:utf-8' })
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_imported_members
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)

    puts "Header row: #{header.inspect}"
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      puts "Row #{i} data: #{row.inspect}"

      member = Member.find_by(member_id: row['member_id']) || Member.new
      begin
        member.attributes = row.to_hash
      rescue ActiveModel::UnknownAttributeError => e
        member.errors.add(:base, "Unknown attribute: #{e.attribute}")
      end
      member
    end
  end

  def imported_members
    @imported_members ||= load_imported_members
  end

  def save
    success = true

    imported_members.each do |member|
      next if member.valid?

      member.errors.full_messages.each do |msg|
        errors.add :base, "Row #{member.id}: #{msg}"
      end
      success = false
    end

    imported_members.each(&:save!) if success

    success
  end
end
