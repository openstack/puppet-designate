# designate server-create --name designate.example.net.
# designate domain-create --name example.net. --email root@example.net
# designate record-create <id> --type A --name www.example.net. --data 127.0.0.1
# designate record-list <id>
# dig www.example.net @127.0.0.1 +short
#
node /designate/ {

  include '::apt'
  include '::rabbitmq'
  include '::mysql::server'

  # Keystone parameters
  $keystone_db_host     = '127.0.0.1'
  $keystone_password    = 'design1tepwd'
  $keystone_db_password = 'admin'
  $keystone_admin_token = '09ebe37c-60e6-11e4-9663-63d2e0838999'

  # This example would install designate api
  # designate central service and designate backend (bind)
  $rabbit_host           = '127.0.0.1'
  $rabbit_userid         = 'guest'
  $rabbit_password       = 'guest'
  $auth_strategy         = 'keystone'
  $designate_db_password = 'admin'
  $db_host               = '127.0.0.1'

  # == Keystone == #
  class { '::keystone::db::mysql':
    password      => $keystone_db_password,
    allowed_hosts =>  '%',
  }

  class { '::keystone':
    validate_service    => true,
    catalog_type        => 'sql',
    enable_pki_setup    => false,
    admin_token         => $keystone_admin_token,
    token_provider      => 'keystone.token.providers.uuid.Provider',
    token_driver        => 'keystone.token.backends.sql.Token',
    database_connection =>  "mysql://keystone:${keystone_db_password}@${keystone_db_host}/keystone",
  }

  ## Adds the admin credential to keystone.
  class { '::keystone::roles::admin':
    email        => 'admin@example.com',
    password     =>  $keystone_password,
    admin_tenant => 'admin',
  }

  ## Installs the service user endpoint.
  class { '::keystone::endpoint': }


  # == Designate == #
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

  include '::designate::client'
  class {'::designate::api':
    auth_strategy     => $auth_strategy,
    keystone_password => $keystone_password,
  }

  include '::designate::central'

  include '::designate::dns'
  class {'::designate::backend::bind9':
    rndc_config_file => '',
    rndc_key_file    => '',
  }

  class {'::designate::keystone::auth':
    password => $keystone_password,
  }
}
