# = Class: typo3::install
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
    cwd 		=> $cwd,
    onlyif	    => "test ! -d typo3_src-${version}"
  }

  exec { "Untar ${name}":
    command 	=> "tar -xzf ${source_file}",
    cwd 		=> $cwd,
    require 	=> Exec["Get ${name}"],
    creates 	=> "${cwd}/typo3_src-${version}"
  }

  exec { "Remove ${cwd}/${source_file}":
    command 	=> "rm -f ${cwd}/${source_file}",
    cwd 		=> $cwd,
    require 	=> Exec["Untar ${name}"]
  }

}