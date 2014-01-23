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
# [*path*]
#   Path to project root.
#   Example: '/var/www/my-project'
#
# [*src_path*]
#   Path to TYPO3 sources.
#   Example: '/var/www'
#
# [*use_symlink*]
#   Set a symlink to TYPO3 source. Set to false to copy sources.
#   Default: true
#
# == Author
# Felix Nagel
#
define typo3::install::source::files (

  $version,
  $path,
  $src_path,
  $use_symlink = true

) {

  include typo3::params

  $source = "${src_path}/typo3_src-${version}"

  if str2bool($use_symlink) {
  
	  file { "${path}/typo3_src":
		ensure  => link,
		target  => $source,
		force   => true,
		replace => true
	  }

	  file { "${path}/index.php":
	    ensure  => link,
		target  => "typo3_src/index.php",
		replace => true,
		require => File["${path}/typo3_src"]
	  }

	  file { "${path}/typo3":
        ensure  => link,
        target	=> "typo3_src/typo3",
        replace	=> true,
        require => File["${path}/typo3_src"]
      }

      if $version !~ /^6\.2/ {

          file { "${path}/t3lib":
            ensure  => link,
            replace => true,
            target	=> "typo3_src/t3lib",
            require => File["${path}/typo3_src"]
          }
      }

  } else {
  
	  file { "${path}/index.php":
		source  => "${source}/index.php",
		ensure => 'present'
	  }

	  file { "${path}/typo3":
        source	=> "${source}/typo3",
        recurse => true,
        ensure => 'present'
      }

      if $version !~ /^6\.2/ {

          file { "${path}/t3lib":
            source  => "${source}/t3lib",
            recurse => true,
            ensure => 'present'
          }
	  }
  }
}