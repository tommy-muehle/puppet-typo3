# = Class: typo3::install::source
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
define typo3::install::source (

  $version,
  $src_path

) {

  include typo3::params

  $source_file = "${version}.tar.gz"

  exec { "Get ${name}":
    command => "wget ${typo3::params::download_url}/${version} -O ${source_file}",
    cwd     => $src_path,
    onlyif  => "test ! -d typo3_src-${version}"
  }

  exec { "Untar ${name}":
    command => "tar -xzf ${source_file}",
    cwd     => $src_path,
    require => Exec["Get ${name}"],
    creates => "${src_path}/typo3_src-${version}"
  }

  exec { "Remove ${path}/${source_file}":
    command => "rm -f ${src_path}/${source_file}",
    cwd     => $src_path,
    require => Exec["Untar ${name}"]
  }

}