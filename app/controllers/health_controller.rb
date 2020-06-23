# frozen_string_literal: true

class HealthController < ApplicationController
  def check
    head :ok
  end
end
