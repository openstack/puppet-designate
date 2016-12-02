node /designate/ {

  include '::apt'
  include '::rabbitmq'
  include '::mysql::server'

  # This example would install designate api and designate central service
  $rabbit_host           = '127.0.0.1'
  $rabbit_userid         = 'guest'
  $rabbit_password       = 'guest'
  $auth_strategy         = 'noauth'
  $designate_db_password = 'admin'
  $db_host               = '127.0.0.1'


  include '::designate::dns'
  include '::designate::backend::bind9'

  class {'::designate::db::mysql':
    password => $designate_db_password,
  }


  class {'::designate':
    rabbit_host     => $rabbit_host,
    rabbit_userid   => $rabbit_userid,
    rabbit_password => $rabbit_password,
  }

  class {'::designate::db':
    database_connection   => "mysql://designate:${designate_db_password}@${db_host}/designate"
  }

  class {'::designate::api':
    auth_strategy => $auth_strategy,
  }

  include '::designate::central'
}
