# Need to set password manually because puppet doesn't know how to set passwords.
# Homedir should not have trailing slash.
# Need to reload apache manually after configtest - to avoid an error which prevents starting.
define newvhost($user, $homedir) {
  $servername = $title
  # creates user and group but no homedir.
  user {$user:
    home => $homedir,
    shell => "/bin/bash",
  }

  file {"/etc/httpd/conf.d/$servername.conf":
    content => template("apachevhost.erb"),
  }

  file {"$homedir/fcgi-bin/php-wrapper":
    mode => 755,
    content => template("php-wrapper.erb"),
    require => [ File["$homedir/fcgi-bin"], User[$user] ],
    owner => $user,
    group => $user,
  }
  
  # create home dir
  file {$homedir:
    ensure => directory,
    group => "apache",
    mode => 750,
    owner => $user,
    require => User[$user],
  }
  file {"$homedir/httpdocs":
    ensure => directory,
    group => $user,
    mode => 755,
    owner => $user,
    require => User[$user],
  }
  file {"$homedir/fcgi-bin":
    ensure => directory,
    group => $user,
    mode => 755,
    owner => $user,
    require => User[$user],
  }
  file {"$homedir/logs":
    ensure => directory,
    group => $user,
    mode => 750,
    owner => "root",
    require => User[$user],
  }
}
