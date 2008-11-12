# methods added to Time to speak the correct time, and a new contructor for
# making a Time from menus

# add a couple of useful formats to ActiveSupport to_formatted_s conversion
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!({
  :date_only => "%e %B %Y",
  :showtime => '%A, %b %e, %l:%M %p',
  :month_day_only => "%b %e"
})

class Time
  def speak(args={})
    res = []
    unless args[:omit_date]
      res << strftime("%A, %B %e")
    end
    unless args[:omit_time]
      say_min = min.zero? ? "" :  min < 10 ? "oh #{min}" : min
      res<<"#{self.strftime('%I').to_i} #{say_min} #{self.strftime('%p')[0,1]} M"
    end
    res.join(", at ")
  end

  def at_end_of_day
    (self + 1.day).midnight - 1.second
  end

  def self.new_from_hash(h)
    return Time.now unless h.respond_to?(:has_key)
    if h.has_key?(:hour)
      Time.local(h[:year].to_i,h[:month].to_i,h[:day].to_i,h[:hour].to_i,
               (h[:minute] || "00").to_i,
               (h[:second] || "00").to_i)
    else
      Time.local(h[:year].to_i,h[:month].to_i,h[:day].to_i)
    end
  end

  def self.from_param(param,default=Time.now)
    (param.blank? ? default :
     (param.kind_of?(Hash) ?
      Time.local(param[:year],param[:month],param[:day]) :
      Time.parse(param)))
  end

  def self.range_from_params(minp,maxp,default=Time.now)
    min = Time.from_param(minp)
    max = Time.from_param(maxp)
    min,max = max,min if min > max
    return min,max
  end
end
