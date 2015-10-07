# Definition: st2_systemd
#
#  Lets create some Systemd scripts
#
define st2_systemd::startup (
  $st2_process  = undef,
  $process_type = single
  ) {

  if $process_type = multi {
    $type = "${process_type}@"
  } else {
    $type = ''
  }

  file{"/etc/systemd/system/${st2_process}${type}.service":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template("st2/etc/systemd/system/st2service_${process_type}.service.erb"),
  }

  exec{'sysctl enable':
    path    => '/bin:/usr/bin:/usr/local/bin',
    command => "systemctl --no-reload enable ${st2_process}",
    require => File["/etc/systemd/system/${st2_process}${type}.service"],
    notify  => Service["${st2_process}"],
  }
}
