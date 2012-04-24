# puppet-apt-cacher-ng

A Puppet module for [apt-cacher-ng], with a `Vagrantfile` for quick
deployment on [Vagrant].

Original author: [Alban Peignier]

Maintainer of this fork: [Garth Kidd]

Other contributors:

* [Gabriel Filion]: version specification, file layout flexibility
* [Lekensteyn]: auto-detect/fallback script (see [askubuntu:54099])

## Installation in Production

* Clone the module into your `/etc/puppet/modules` directory:

        cd /etc/puppet/modules
        git clone git://github.com/garthk/puppet-apt-cacher-ng apt-cacher-ng

* Edit the definition for your server to include `apt-cacher-ng`, perhaps
  specifying `version`:

        class { 'apt-cacher-ng':
          # version => '0.4.6-1ubuntu1',
        }

    The server will be available at the default port (3142).

    The server will not use itself as a cache by default. 

* Edit the definition for your clients to include `apt-cacher-ng::client`:

        class { 'apt-cacher-ng::client':
          server  => "192.168.31.42:3142",
        }

* To specify more than one server:

        class { 'apt-cacher-ng::client':
          servers => ["192.168.30.42:3142", "192.168.31.42:3142"],
        }

* To disable fallback to direct access if the proxy is not available:

        class { 'apt-cacher-ng::client':
          autodetect => false,
          server     => "192.168.31.42:3142",
        }

    Per [askubuntu:54099], you'll need to do this on older Ubuntu and Debian
    releases. Lucid and Squeeze support `Acquire::http::ProxyAutoDetect`;
    Karmic and Lenny don't.

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

    You could also install the Puppet module and use `apt-cacher-ng::client`
    as above. 

## Testing

To perform a [smoke test]: 

    make smoke

To smoke test both the module and the `Vagrantfile`'s `manifest_file`:

    make test

To test the module properly, install [Vagrant] and:

    make vm

[apt-cacher-ng]: http://www.unix-ag.uni-kl.de/~bloch/acng/
[smoke test]: http://docs.puppetlabs.com/guides/tests_smoke.htm
[Alban Peignier]: https://github.com/albanpeignier
[Garth Kidd]: https://github.com/garthk
[Gabriel Filion]: https://github.com/lelutin
[Lekensteyn]: http://www.lekensteyn.nl/
[Vagrant]: http://vagrantup.com/
[host-only networking]: http://vagrantup.com/docs/host_only_networking.html
[askubuntu:54099]: http://askubuntu.com/a/54099
[Puppet Provisioning]: http://vagrantup.com/docs/provisioners/puppet.html
