class DownloadInquiry < Inquiry
  belongs_to :person
  # write_inheritable_attribute :validate, nil #set the validations from top level nil so we can reset
  validates_acceptance_of :agreement
  attr_accessor :agreement
end