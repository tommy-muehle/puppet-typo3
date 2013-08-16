# = Class: typo3::install
#
# == Parameters
#
# Standard class parameters
#
# [*version*]
#
# [*cwd*]
#
# == Author
# Tommy Muehle
#
define typo3::install (

  $version,
  $cwd

) {

  include typo3::params

  $source_file = "${version}.tar.gz"

  exec { "Get ${name}":
      command 	=> "wget ${typo3::params::download_url}/${version} -O ${source_file}",
      cwd 		=> $cwd
  }

  exec { "Untar ${name}":
    command 	=> "tar -xzf ${source_file}",
    cwd 		=> $cwd,
    require 	=> Exec["Get ${name}"],
    creates 	=> "${cwd}/typo3_src-${version}"
  }

  file { "${cwd}/${source_file}":
    require 	=> Exec["Untar ${name}"],
    ensure 		=> absent
  }

}