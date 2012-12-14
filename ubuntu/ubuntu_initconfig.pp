# If sshd requires password access change
#   PasswordAuthentication yes

define disabletty() {
  $num = $title
  file {"/etc/init/tty$num.override": content => template("ttyX.override") }
}

disabletty {"2": }
disabletty {"3": }
disabletty {"4": }
disabletty {"5": }
disabletty {"6": }

file {"/etc/sysctl.conf": }

exec { "/sbin/sysctl -p":
      alias => "sysctl",
      refreshonly => true,
      subscribe => File["/etc/sysctl.conf"],
}

augeas {"disableIPv6":
  context => "/files/etc/sysctl.conf",
  changes => [ "set net.ipv6.conf.all.disable_ipv6 1" ],
}

package {"auditd": ensure => installed}
package {"sysstat": ensure => installed}

augeas {"enable_sysstat": 
  context => "/files/etc/default/sysstat",
  changes => [ "set ENABLED true" ],
  require => Package["sysstat"],
}

file {"/etc/cron.d/sysstat": content => template("etc/cron.d/sysstat")}

exec {"enable_multiverse": 
  command => "/usr/bin/perl -lpi -e 's/# *(deb.*multiverse$)/\$1/' /etc/apt/sources.list",
}

file {"/root/.selected_editor": content => template("selected_editor")}
