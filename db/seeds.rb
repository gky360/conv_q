User.create({ "name"=>"admin", "account"=>"conv_q_admin", "status"=>0, "email"=>"scarletrunner7000@gmail.com", "password"=> "hogehoge" })
(1..10).each do |n|
  User.create({ "name"=>"user_#{n}", "account"=>"user_#{n}", "status"=>0, "email"=>"user_#{n}@gmail.com", "password"=> "hogehoge" })
end
