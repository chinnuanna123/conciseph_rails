# frozen_string_literal: true

module Api
  module V1
    class MedicationsController < ApiController
      before_action :set_medication, only: %i[update show destroy]
      before_action :set_user_or_family_member, only: %i[create]
      def index; end

      def show; end

      def create
        mobile_app_uuid = params[:mobile_app_uuid]
        @medication = Medication.find_by(mobile_app_uuid: mobile_app_uuid)
        return if @medication.present? && mobile_app_uuid.present?

        @medication = @user.medications.build(medication_params)
        return if @medication.save

        render status: 500, json: { status: 'error', error: @medication.errors.full_messages }
      end

      def update
        # if params[:medication_timings_attributes].present?
        #   uuid_array = params[:medication_timings_attributes].map { |timings| timings[:mobile_app_uuid] }
        #   @medication.medication_timings.each do |mt|
        #     mt.mark_for_destruction if uuid_array.include?(mt.mobile_app_uuid)
        #   end
        # end

        @medication.medication_timings.each(&:mark_for_destruction) if is_timing_update?

        @medication.assign_attributes(medication_params)
        return if @medication.save

        render status: 422, json: { status: 'error', errors: @medication.errors.full_messages }
        true
      end

      def destroy
        @medication.destroy

        if @medication.destroyed?
          render json: { message: 'Medication and associated records destroyed successfully' }, status: :ok
        else
          render json: { errors: @medication.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def medication_params
        params.permit(
          :mobile_app_uuid, :name, :medication_type, :dosage_qty, :dosage_count, :dosage_count_cycle_name, :dosage_days, :dosage_cycle_name, :start_date, :end_date, :medication_timing_count, :delete_medication_timings,
          medication_timings_attributes: %i[
            id mobile_app_uuid scheduled_time qty taken_at _destroy
          ]
        )
      end

      def set_medication
        @medication = Medication.find_by(id: params[:id])
      end

      def set_user_or_family_member
        @user = User.find_by(id: params[:family_member_id]) || current_user
      end

      def is_timing_update?
        dosage_count_changed = params[:dosage_count] != @medication.dosage_count
        dosage_count_cycle_name_changed = params[:dosage_count_cycle_name] != @medication.dosage_count_cycle_name_before_type_cast
        dosage_days_changed = params[:dosage_days] != @medication.dosage_days
        dosage_cycle_name_changed = params[:dosage_cycle_name] != @medication.dosage_cycle_name_before_type_cast
        # start_changed = Time.parse(params[:start_date]) != @medication.start_date
        # end_changed = Time.parse(params[:end_date]) != @medication.end_date

        dosage_count_changed || dosage_count_cycle_name_changed || dosage_days_changed || dosage_cycle_name_changed # || start_changed || end_changed
      end
    end
  end
end
