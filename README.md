# Custom Images in hcloud

Experiments in creating custom images in Hetzner Cloud

## Sources

* https://yum.oracle.com/oracle-linux-templates.html

## TODO

* [ ] IPv6 on RHEL/OEL 7 seems not to work by route, and DNS fails because of IPv6 addresses

  Temp Fix:

    cp /etc/resolv.conf.save /etc/resolv.conf
    echo PEERDNS=no >>/etc/sysconfig/network-scripts/ifcfg-eth0

## License

[CC-BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/)
