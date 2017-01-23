testlink::instance { 'my_testlink1':
  db_password => 'super_long_password',
  db_name     => 'testlink1',
  db_user     => 'testlink1_user'
  port        => '80',
  status      => 'present'
}
