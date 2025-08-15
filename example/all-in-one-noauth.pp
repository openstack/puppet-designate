node /designate/ {

  include apt
  include rabbitmq
  include mysql::server

  # This example would install designate api and designate central service
  $auth_strategy         = 'noauth'
  $designate_db_password = 'admin'
  $db_host               = '127.0.0.1'


  include designate::dns
  include designate::backend::bind9

  class {'designate::db::mysql':
    password => $designate_db_password,
  }


  class {'designate':
    default_transport_url => os_transport_url({
        'transport'    => 'rabbit',
        'host'         => '127.0.0.1',
        'username'     => 'guest',
        'password'     => 'guest',
        'virtual_host' => '/',
    }),
  }

  class {'designate::db':
    database_connection => "mysql://designate:${designate_db_password}@${db_host}/designate",
  }

  class {'designate::api':
    auth_strategy => $auth_strategy,
  }

  include designate::central
}
