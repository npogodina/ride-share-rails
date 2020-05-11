class Trip < ApplicationRecord
  belongs_to :driver, optional: true
  belongs_to :passenger, optional: true
end
