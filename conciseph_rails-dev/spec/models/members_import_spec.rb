# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersImport, type: :model do
  let(:file) { Rails.public_path.join('sample.csv') }
  let(:members_import) { MembersImport.new(file: file) }

  # describe '#open_spreadsheet' do
  #   let(:file) do
  #     # Create a double to mock file behavior
  #     double('file', original_filename: 'sample.csv', path: Rails.public_path.join('sample.csv'))
  #   end
  #   context 'when importing a CSV file' do
  #     it 'opens the spreadsheet as a CSV' do
  #       expect(Roo::CSV).to receive(:new).with(file.to_s, csv_options: { encoding: 'iso-8859-1:utf-8' })
  #       members_import.open_spreadsheet
  #     end
  #   end
  # end

  describe '#load_imported_members' do
    it 'loads members from the spreadsheet' do
      allow(members_import).to receive(:open_spreadsheet).and_return(Roo::CSV.new(file.to_s))

      members = members_import.load_imported_members
      expect(members.size).to eq(1) # Assuming 3 rows in the fixture file (excluding header)
      expect(members.first).to be_a(Member)
    end

    it 'handles unknown attributes gracefully' do
      allow(members_import).to receive(:open_spreadsheet).and_return(Roo::CSV.new(file.to_s))
      allow(Member).to receive(:find_by).and_return(Member.new)

      allow_any_instance_of(Member).to receive(:attributes=).and_raise(ActiveModel::UnknownAttributeError.new(
                                                                         Member.new, 'unknown_attr'
                                                                       ))

      expect { members_import.load_imported_members }.not_to raise_error
    end
  end

  describe '#save' do
    let(:member) { build(:member) }

    before do
      allow(members_import).to receive(:imported_members).and_return([member])
    end

    context 'when all members are valid' do
      it 'saves all members' do
        allow(member).to receive(:valid?).and_return(true)
        expect(member).to receive(:save!).once
        expect(members_import.save).to be true
      end
    end

    context 'when a member is invalid' do
      it 'does not save any members and adds errors' do
        allow(member).to receive(:valid?).and_return(false)
        allow(member).to receive_message_chain(:errors, :full_messages).and_return(['Invalid member data'])

        expect(member).not_to receive(:save!)
        expect(members_import.save).to be false
        expect(members_import.errors[:base]).to include('Row : Invalid member data')
      end
    end
  end
end
