module Generic::PeopleController
  extend ActiveSupport::Concern
  included do
    self.permitted_attrs += [:payment_method, :iban, :bic, :account_holder]
  end
end
