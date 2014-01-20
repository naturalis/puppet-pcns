# == Class: pcns
#
# Full description of class pcns here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { pcns:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class pcns (
  $NMCIP,
  $NMCusername,
  $NMCpassword,
  $NMSauthenticationPhrase,
  ){

 file { "/tmp/install.sh":
    content       => template('pcns/install.sh.erb'),
    mode          => '0700',
  }

 file { "/tmp/silentInstall":
    content       => template('pcns/silentInstall.erb'),
    mode          => '0640',
  }

  file {"/tmp/jre-7u45-linux-x64.tar.gz":
    source        => "puppet:///modules/pcns/jre-7u45-linux-x64.tar.gz",
    ensure        => "present",
  }

  file {"/tmp/pcns310.tar.gz":
    source        => "puppet:///modules/pcns/pcns310.tar.gz",
    ensure        => "present",
  }

  exec {"extract-java":
    command   => "/bin/tar -xzf /tmp/jre-7u45-linux-x64.tar.gz",
    cwd       => "/opt",
    unless    => "/usr/bin/test -d /opt/jre1.7.0_45",
    require   => File["/tmp/jre-7u45-linux-x64.tar.gz"],  
  }

  exec {"run-install-script":
    command   => "/tmp/install.sh -f /tmp/silentInstall",
    cwd       => "/tmp",
    unless    => "/usr/bin/test -d /opt/APC",
    require   => [Exec["extract-java"],
                  File["/tmp/install.sh"],
                  File["/tmp/pcns310.tar.gz"]],
  }
}
