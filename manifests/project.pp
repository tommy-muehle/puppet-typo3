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
# [*local_conf*]
#   Set some parameters for pre-set in LocalConfiguration file.
#   Default: (empty hash)
#
# [*extensions*]
#   Set some extensions and parameters for pre-install.
#   Default: (empty array)
#
# [*use_symlink*]
#   Set a symlink to TYPO3 source. Set to false to copy sources.
#   Default: true
#
# [*enable_install_tool*]
#   Enables the TYPO3 install tool for one hour.
#   Default: false
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

  $local_conf = {},
  $extensions = [],

  $use_symlink = true,
  $enable_install_tool = false

) {

  include typo3

  if ( $site_user != $site_group ) {
    $dir_permission     = 2770
    $file_permission    = 660
  } else {
    $dir_permission     = 2755
    $file_permission    = 644
  }

  if ( $typo3_src_path == "" or $typo3_src_path == undef ) {
    $typo3_src = $site_path
  } else {
    $typo3_src = $typo3_src_path
  }

  typo3::install::source { "${name}-${version}":
    version  => $version,
    src_path => $typo3_src,
  }

  typo3::install::source::files { "${name}-${version}":
    version     => $version,
    src_path    => $typo3_src,
    site_path   => $site_path,
    use_symlink => $use_symlink,
    require     => Typo3::Install::Source["${name}-${version}"]
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

  if $enable_install_tool == true {

    file { "${site_path}/typo3conf/ENABLE_INSTALL_TOOL":
      replace => "no",
      ensure  => "present",
      mode    => $file_permission,
      content => '',
      require => File["${site_path}/typo3conf"],
    }

  } else {

    tidy { "${site_path}/typo3conf/ENABLE_INSTALL_TOOL":
      age => "1h"
    }

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