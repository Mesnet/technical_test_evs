class Api::V1::PricesController < ApplicationController
  before_action :validate_date_param, only: [:index]

  def index
    date = Date.parse(params[:date])
    @prices = Price.where(recorded_at: date.all_day).ordered_by_recorded_at
  end

  private

  def validate_date_param
    if params[:date].blank?
      render json: { error: 'Date parameter is required' }, status: :bad_request
    elsif !parsed_date(params[:date])
      render json: { error: 'Invalid date format. Please use YYYY-MM-DD format' }, status: :bad_request
    end
  end

  def parsed_date(date_str)
    Date.strptime(date_str, '%Y-%m-%d')
  rescue ArgumentError, TypeError
    nil
  end
end
