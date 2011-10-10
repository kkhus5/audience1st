class AddWalkupAttributeToVouchers < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :walkup, :boolean, :null => false, :default => false
    purchasemethod_ids = Purchasemethod.walkup_purchasemethods.map(&:id)
    Voucher.find(:all,
      :conditions => ['showdate_id > 0 AND category != ? AND purchasemethod_id IN (?)', :nonticket, purchasemethod_ids]).each do |v|
      sd = v.showdate.thedate
      if v.sold_on.between?(sd - 2.hours, sd + 2.hours)
        v.update_attribute(:walkup, true)
      end
    end
  end

  def self.down
    remove_column :vouchers, :walkup
  end
end
