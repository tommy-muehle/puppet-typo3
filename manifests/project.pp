# = Class: typo3::project
#
# == Parameters
#
# Standard class parameters
#
# [*version*]
#   TYPO3 version for project.
#   Example: '6.1.3'
#
# [*typo3_src_path*]
#   Path to TYPO3 sources.
#   Example:  '/var/www/'
#
# [*site_path*]
#   Path to project root.
#   Example:  '/var/www/my-project'
#
# [*site_user*]
#   Project files owner.
#   Example: 'vagrant'
#
# [*site_group*]
#   Project files group.
#   Example: 'www-data'
#
# [*db_pass*]
#   Set the password for the database.
#   Default: '' (empty)
#
# [*db_user*]
#   Set the user for the database.
#   Default: '' (empty)
#
# [*db_host*]
#   Set the the database host.
#   Default: '' (empty)
#
# [*db_name*]
#   Set the database name.
#   Default: '' (empty)
#
# == Author
# Tommy Muehle
#
define typo3::project (

  $version,
  $typo3_src_path = "",
  $site_path,
  $site_user,
  $site_group,

  $db_pass = "",
  $db_user = "",
  $db_host = "",
  $db_name = "",

  $local_conf = [],
  $extensions = [],

) {

  include typo3

  if ( $site_user != $site_group ) {
    $dir_permission     = 2770
    $file_permission    = 660
  } else {
    $dir_permission     = 2755
    $file_permission    = 644
  }

  unless ( $typo3_src_path ) {
    $typo3_src_path     = $site_path
  }

  typo3::install::source { "${name}-${version}":
    version => $version,
    path    => $typo3_src_path,
  }

  typo3::install::extension { $extensions:
    path    => "${site_path}/typo3conf/ext",
    owner   => $site_user,
    group   => $site_group,
  }

  File {
    owner   => $site_user,
    group   => $site_group
  }

  file { "${site_path}/typo3_src":
    ensure  => 'link',
    target  => "${typo3_src_path}/typo3_src-${version}",
    force   => true,
    replace => true,
    require => Typo3::Install::Source["${name}-${version}"]
  }

  exec { "ln -s typo3_src/index.php index.php":
    command => 'ln -s typo3_src/index.php index.php',
    cwd     => $site_path,
    require => File["${site_path}/typo3_src"],
    unless  => 'test -L index.php',
  }

  unless $version =~ /^6\.2/ {
    exec { "ln -s typo3_src/t3lib t3lib":
      command   => 'ln -s typo3_src/t3lib t3lib',
      cwd       => $site_path,
      require   => File["${site_path}/typo3_src"],
      unless    => 'test -L t3lib',
    }
  }

  exec { "ln -s typo3_src/typo3 typo3":
    command => 'ln -s typo3_src/typo3 typo3',
    cwd     => $site_path,
    require => File["${site_path}/typo3_src"],
    unless  => 'test -L typo3',
  }

  file {[
    "${site_path}/typo3temp",
    "${site_path}/fileadmin",
    "${site_path}/fileadmin/user_upload",
    "${site_path}/fileadmin/_temp_",
    "${site_path}/uploads",
    "${site_path}/uploads/pics",
    "${site_path}/uploads/media",
    "${site_path}/uploads/tf",
    "${site_path}/typo3conf",
    "${site_path}/typo3conf/l10n",
    "${site_path}/typo3conf/ext"
  ]:
    ensure  => "directory",
    mode    => $dir_permission
  }

  file { "${site_path}/typo3conf/extTables.php":
    replace => "no",
    ensure  => "present",
    content => template('typo3/extTables.php.erb'),
    require => File["${site_path}/typo3conf"]
  }

  file {[
    "${site_path}/fileadmin/.htaccess",
    "${site_path}/typo3conf/.htaccess",
    "${site_path}/typo3conf/ext/.htaccess",
    "${site_path}/uploads/.htaccess"
  ]:
    replace => "no",
    ensure  => "present",
    mode    => $file_permission,
    content => template('typo3/.htaccess.erb'),
    require => [
      File["${site_path}/fileadmin"],
      File["${site_path}/typo3conf"],
      File["${site_path}/typo3conf/ext"],
      File["${site_path}/uploads"]
    ]
  }

  if $version =~ /^4\./ {

    file { "${site_path}/typo3conf/localconf.php":
      replace   => "no",
      ensure    => "present",
      content   => template('typo3/localconf.php.erb'),
      mode      => $file_permission,
      require   => File["${site_path}/typo3conf"],
    }

  } elsif $version =~ /^6\./ {

    File {
      replace   => "no",
      ensure    => "present",
      mode      => $file_permission
    }

    file { "${site_path}/typo3conf/LocalConfiguration.php":
      content   => template('typo3/LocalConfiguration.php.erb'),
    }

    file { "${site_path}/typo3conf/AdditionalConfiguration.php":
      content   => template('typo3/AdditionalConfiguration.php.erb'),
    }

    file {[
      "${site_path}/fileadmin/_processed_"
    ]:
      ensure    => "directory",
      mode      => $dir_permission,
      require   => File["${site_path}/fileadmin"]
    }

  }
}