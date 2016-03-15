# users

user = User.where(name: "Admin", account: "admin", email: "scarletrunner7000@gmail.com").first_or_initialize
user.password = "hogehoge"
user.save
user.admin!
(1..10).each do |n|
  user = User.where(name: "user_#{n}", account: "user_#{n}", email: "user_#{n}@gmail.com").first_or_initialize
  user.password = "hogehoge"
  user.save
end


# reports

(1..10).each do |user_id|
  (1..10).each do |n|
    detail = ""
    10.times do
      detail += "report detail #{n}. "
    end
    Report.where(topic_id: n, user_id: user_id, detail: detail).first_or_create
    # TODO: reason flag
  end
end
Report.first.update(reason_flag: (1 << 31) - 1)
