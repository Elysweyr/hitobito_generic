module Generic::Person
  extend ActiveSupport::Concern

  included do
    # Person::PUBLIC_ATTRS << :payment_method << :iban << :bic << :account_holder
    validates :iban, iban: true, allow_blank: true, :if => lambda { self.payment_method == "sepa" }
    validates :bic, bic: true, allow_blank: true, :if => lambda { self.payment_method == "sepa" }
    validates_presence_of :iban, :bic, :account_holder, :if => lambda { self.payment_method == "sepa" }

    def iban
      sepa? ? self[:iban] : ""
    end

    def bic
      sepa? ? self[:bic] : ""
    end

    def account_holder
      sepa? ? self[:account_holder] : ""
    end

    private

    def sepa?
      self[:payment_method] == 'sepa'
    end
  end

end

class PaymentMethod
  I18N_KEY_PREFIX = 'activerecord.models.payment_method'.freeze

  class << self

    def available
      I18n.t("#{I18N_KEY_PREFIX}.available")
    end

  end


end

class IbanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Iban.new(value).valid?
      record.errors.add(attribute, "ungültig")
    end
  end

  class Iban
    attr_reader :value, :country_code, :checksum, :bban

    def initialize(string)
      @value = string.upcase.delete(' ')
      parse_iban
    end

    def parse_iban
      if @matches = @value.match(/(?<country_code>[a-z]{2})(?<checksum>[0-9]{2})(?<bban>[0-9]+)/i)
        @country_code = @matches[:country_code]
        @checksum = @matches[:checksum]
        @bban = @matches[:bban]
      end
    end

    def numberical_country_code
      @country_code.upcase.each_char.map { |char| char.ord - 64 + 9}
    end

    def valid_checksum?
      sum = [@bban, numberical_country_code, "00"].flatten.join.to_i
      modulo = sum % 97
      @checksum.to_i == 98 - modulo
    end

    def valid?
      @country_code && @checksum && @bban && valid_checksum? && ( @matches.to_s == @value)
    end
  end
end

class BicValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless valid?(value)
      record.errors.add(attribute, "ungültig")
    end
  end

  def self.valid?(bic)
    return false unless bic.length == 8 || bic.length == 11
    bic.match(/[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?/i)
  end


  private

  def valid?(bic)
    return false unless bic.length == 8 || bic.length == 11
    bic.match(/[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?/i)
  end
end
