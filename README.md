# puppet-apt-cacher-ng

A Puppet module for [apt-cacher-ng], with a `Vagrantfile` for quick
deployment on [Vagrant].

Original author: [Alban Peignier]

Maintainer of this fork: [Garth Kidd]

## Installation in Production

To install the Puppet module so you can provide an apt cache for your
environment: 

    cd /etc/puppet/modules
    git clone git://github.com/garthk/puppet-apt-cacher-ng apt-cacher-ng

To deploy the server:

    class { 'apt-cacher-ng':
    }

The server will be available at the default port (3142).

To use it from your clients:

    $aptcache_url = "http://192.168.31.42:3142"
    file { "/etc/apt/apt.conf.d/71proxy": 
      owner   => root,
      group   => root,
      mode    => '0644',
      content => 'Acquire::http { Proxy "${aptcache_url}"; };',
    }

(Of course, I plan to put this in the module, too...)

## Providing an apt cache for your Vagrant virtual machines

To install apt-cacher-ng on a fresh box in [Vagrant]:

    vagrant up aptcache

The `Vagrantfile` specifies a box named `aptcache` providing its service
from `http://192.168.31.42:3142`. You should be able to browse to it from
your host OS to manage it.

### Using the apt cache

To configure your own Vagrant box to access the `aptcache` box:

* Configure your VM for [host-only networking], by adding the following line
  to your `Vagrantfile`:

        config.vm.network :hostonly, "192.168.31.2"

    (Change the final octet (`2`) to make sure it's unique on your machine. 
    Don't use `1`: it'll probably be used by your host OS for its `vboxnet0`
    adapter.)

* Inside your box, create `/etc/apt/apt.conf.d/71proxy` with the line:

        Acquire::http { Proxy "http://192.168.31.42:3142"; };

    If you're using [Puppet Provisioning], put this in your `manifest_file`, 
    e.g. `my_manifest.pp`:

        file { "/etc/apt/apt.conf.d/71proxy": 
          owner   => root,
          group   => root,
          mode    => '0644',
          content => 'Acquire::http { Proxy "http://192.168.31.42:3142"; };',
        }

It's also possible to use the proxy if it's available but fetch directly
otherwise, according to [askubuntu:54099]. 

## Testing

To perform a [smoke test]: 

    make test

To test the module properly, install [Vagrant] and:

    make vm

[apt-cacher-ng]: http://www.unix-ag.uni-kl.de/~bloch/acng/
[smoke test]: http://docs.puppetlabs.com/guides/tests_smoke.htm
[Alban Peignier]: https://github.com/albanpeignier
[Garth Kidd]: https://github.com/garthk
[Vagrant]: http://vagrantup.com/
[host-only networking]: http://vagrantup.com/docs/host_only_networking.html
[askubuntu:54099]: http://askubuntu.com/a/54099
[Puppet Provisioning]: http://vagrantup.com/docs/provisioners/puppet.html
