class Customer < ActiveRecord::Base
  default_scope {  order('last_name, zip').distinct }

  scope :regular_customers, ->()  { where('role >= 0') }
  
  scope :subscriber_during, ->(seasons) {
    joins(:vouchertypes).
    where('vouchertypes.subscription = ? AND vouchertypes.season IN (?)', true, seasons)
  }

  scope :purchased_any_vouchertypes, ->(vouchertype_ids) {
    joins(:vouchertypes).where('vouchertypes.id IN (?)', vouchertype_ids)
  }
  
  scope :purchased_no_vouchertypes, ->(vouchertype_ids) {
    matching_vouchers = Voucher.where('items.customer_id = customers.id').where('items.vouchertype_id IN (?)', vouchertype_ids)
    where("NOT EXISTS(#{matching_vouchers.to_sql})")
  }

  # def self.purchased_no_vouchertypes(vouchertype_ids)
  #   Customer.all - Customer.purchased_any_vouchertypes(vouchertype_ids)
  # end

  scope :seen_any_of, ->(show_ids) {
    joins(:vouchers, :showdates).
    where('items.customer_id = customers.id AND items.showdate_id = showdates.id AND
           items.type = \'Voucher\' AND showdates.show_id IN (?)', show_ids)
  }
  
  def self.seen_none_of(show_ids)
    not_seen_these_shows = Customer.
      includes(:vouchers, :showdates).
      where.not(:showdates => {:show_id => show_ids})
    not_seen_any_shows = Customer.
      includes(:vouchers, :showdates).
      where(:items => {:customer_id => nil})
    not_seen_these_shows.or(not_seen_any_shows).distinct
  end

  scope :with_open_subscriber_vouchers, ->(vtypes) {
    joins(:items).
    where('items.customer_id = customers.id AND items.type = \'Voucher\' AND
                       (items.showdate_id = 0 OR items.showdate_id IS NULL) AND
                       items.vouchertype_id IN (?)', vtypes)
  }

  scope :donated_during, ->(start_date, end_date, amount) {
    joins(:items, :orders).
    where(%q{items.customer_id = customers.id AND items.amount >= ? AND items.type = 'Donation'
            AND orders.sold_on BETWEEN ? AND ?},
      amount, start_date, end_date)
  }

end
