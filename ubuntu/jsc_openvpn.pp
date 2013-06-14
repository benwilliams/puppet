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
