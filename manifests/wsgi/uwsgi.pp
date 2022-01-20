#
# Copyright 2021 Thomas Goirand <zigo@debian.org>
#
# Author: Thomas Goirand <zigo@debian.org>
#
# == Class: designate::wsgi::uwsgi
#
# Configure the UWSGI service for Designate API.
#
# == Parameters
#
# [*processes*]
#   (Optional) Number of processes.
#   Defaults to $::os_workers.
#
# [*threads*]
#   (Optional) Number of threads.
#   Defaults to 32.
#
# [*listen_queue_size*]
#   (Optional) Socket listen queue size.
#   Defaults to 100
#
class designate::wsgi::uwsgi (
  $processes         = $::os_workers,
  $threads           = 32,
  $listen_queue_size = 100,
){

  include designate::deps

  if $::operatingsystem != 'Debian' {
    warning('This class is only valid for Debian, as other operating systems are not using uwsgi by default.')
  }

  designate_api_uwsgi_config {
    'uwsgi/processes': value => $processes;
    'uwsgi/threads':   value => $threads;
    'uwsgi/listen':    value => $listen_queue_size;
  }
}
