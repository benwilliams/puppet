file {"/etc/sysconfig/network-scripts/ifcfg-eth0": content => template("ifcfg-eth0") }
file {"/etc/sysconfig/network-scripts/ifcfg-eth3": content => template("ifcfg-eth3") }
file {"/etc/modprobe.d/bonding.conf": content => template("bonding.conf") }
file {"/etc/sysconfig/network-scripts/ifcfg-bond0": content => template("ifcfg-bond0") }


file {"/etc/resolv.conf": content => template("resolv.conf") }

define newbridge($ip, $netmask, $vlan) {
  file {"/etc/sysconfig/network-scripts/ifcfg-bond0.$vlan": content => template("ifcfg-bond0.X.erb") }
  file {"/etc/sysconfig/network-scripts/ifcfg-br$vlan": content => template("ifcfg-brX.erb") }
}

case $hostname {
  cnwmelm2: {
    $gateway = "143.96.74.1"
    file {"/etc/sysconfig/network": content => template("network.erb") }
    newbridge {"mgmt": ip => "143.96.74.5", netmask => "255.255.255.192", vlan => "10" }
    newbridge {"voipdmz": ip => "", netmask => "", vlan => "11" }
  }
  cnwmelm3: {
    $gateway = "143.96.74.1"
    file {"/etc/sysconfig/network": content => template("network.erb") }
    newbridge {"mgmt": ip => "143.96.74.6", netmask => "255.255.255.192", vlan => "10" }
    newbridge {"voipdmz": ip => "", netmask => "", vlan => "11" }
  }
  h1: {
    $gateway = "143.96.27.129"
    file {"/etc/sysconfig/network": content => template("network.erb") }
    newbridge {"mgmt": ip => "143.96.27.147", netmask => "255.255.255.128", vlan => "404" }
    newbridge {"voipdmz": ip => "10.194.0.10", netmask => "255.255.255.0", vlan => "8" }
  }
}
