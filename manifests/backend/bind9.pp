class designate::backend::bind9 (
  $rndc_host        = '127.0.0.1',
  $rndc_port        = '953',
  $rndc_config_file = '/etc/rndc.conf',
  $rndc_key_file    = '/etc/rndc.key'
) {

  designate_config {
    'backend:bind9/rndc_host'         : value => $rndc_host;
    'backend:bind9/rndc_port'         : value => $rndc_port;
    'backend:bind9/rndc_config_file'  : value => $rndc_config_file;
    'backend:bind9/rndc_key_file'     : value => $rndc_key_file;
  }
}
