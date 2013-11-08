# = Class: typo3::install::source::files
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
define typo3::install::source::files (

  $version,
  $path,
  $use_symlink = true

) {

  include typo3::params

  $source = "${path}/typo3_src-${version}"
  $target = "${path}/typo3_src"
    
  if $use_symlink  == 'true' {
  
	  file { "${target}":
		ensure  => "${source}",
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

  } else {
  
	  file { "${path}/index.php":
		source  => "${source}/index.php",
		ensure => 'present'
	  }

	  file { "${path}/t3lib":
		source  => "${source}/t3lib",
		recurse => true,
		ensure => 'present'
	  }

	  file { "${path}/typo3":
		source	=> "${source}/typo3",
		recurse => true,
		ensure => 'present'
	  }
    
  }
  
}