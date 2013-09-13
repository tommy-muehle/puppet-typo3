# = Class: typo3::install::symlinks
#
# == Parameters
#
# Standard class parameters
#
# [*version*]
#   TYPO3 version for project.
#   Example: '6.1.3'
#
# [*cwd*]
#   Path to project root.
#   Example: '/var/www/my-project'
#
# == Author
# Felix Nagel
#
define typo3::install::symlinks (

  $version,
  $path

) {

  include typo3::params

  $target = "${path}/typo3_src"
  
  file { "${target}":
    ensure  => "${path}/typo3_src-${version}",
    force   => true,
    replace => true
  }

  file { "${path}/index.php":
    ensure  => "${target}/index.php",
    replace => true,
    require => File["${target}"]	
  }

  file { "${path}/t3lib":
    ensure  => "${target}/t3lib",
    replace => true,
    require => File["${target}"]
  }

  file { "${path}/typo3":
    ensure	=> "${target}/typo3",
    replace	=> true,
    require => File["${target}"]
  }

}