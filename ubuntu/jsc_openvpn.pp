package {"dnsmasq": ensure => "installed"}
package {"openvpn": ensure => "installed"}

# augeus don't understand this file.
# just adds supersede domain-search "cnw.co.nz";
file {"/etc/dhcp/dhclient.conf": content => template("etc/dhcp/dhclient.conf"), require => Package["dnsmasq"]}

file {"/etc/openvpn": source => "file:///root/puppet/commonfiles/openvpn/", recurse => true, require => Package["openvpn"] }

service {"openvpn": enable => true}
service {"dnsmasq": enable => true, subscribe => File["/etc/dhcp/dhclient.conf"]}

file {"/etc/network/if-pre-up.d/iptables": mode => 770, content => template("etc/network/if-pre-up.d/iptables") }
# don't apply rules to after reboot so connection not cut.
file {"/etc/iptables.rules": mode => 660, source => "file:///root/puppet/commonfiles/iptables.txt"}

augeas {"dnsmasq":
  context => "/files/etc/dnsmasq.conf",
  changes => [ "set server[1] /96.143.in-addr.arpa/143.96.31.69",
               "set server[2] /96.143.in-addr.arpa/143.96.28.100",
               "set server[3] /cnw.co.nz/143.96.31.69",
               "set server[4] /cnw.co.nz/143.96.28.100",
               "set server[5] /jadeworld.com/143.96.31.69",
               "set server[6] /jadeworld.com/143.96.28.100",
             ],
}
