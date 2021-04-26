require 'rails_helper'

RSpec.describe User, type: :model do
  # spec/models/todo_spec.rb

  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:events).dependent(:destroy) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:last_name) }
end
