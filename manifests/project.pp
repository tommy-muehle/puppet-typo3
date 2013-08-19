# = Class: typo3::project
#
# == Parameters
#
# Standard class parameters
#
# [*version*]
#
# [*site_path*]
#
# [*site_user*]
#
# [*site_group*]
#
# [*db_pass*]
#
# [*db_user*]
#
# [*db_host*]
#
# [*db_name*]
#
# == Author
# Tommy Muehle
#
define typo3::project (

  $version,
  $site_path,
  $site_user,
  $site_group,

  $db_pass = "",
  $db_user = "",
  $db_host = "",
  $db_name = ""

) {

  include typo3

  typo3::install { "${name}-${version}":
    version => $version,
    cwd	   	=> $site_path
  }

  File {
    owner  	=> $site_user,
    group  	=> $site_group
  }

  file { "${site_path}/typo3_src":
    ensure  => "${site_path}/typo3_src-${version}",
    force   => true,
    replace => true,
    require => Typo3::Install["${name}-${version}"]
  }

  file { "${site_path}/index.php":
    ensure  => "${site_path}/typo3_src/index.php",
    replace => true,
    require => File["${site_path}/typo3_src"]
  }

  file { "${site_path}/t3lib":
    ensure  => "${site_path}/typo3_src/t3lib",
    replace => true,
    require => File["${site_path}/typo3_src"]
  }

  file { "${site_path}/typo3":
    ensure	=> "${site_path}/typo3_src/typo3",
    replace	=> true,
    require => File["${site_path}/typo3_src"]
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
    mode	=> 755
  }

  file {[
    "${site_path}/fileadmin/.htaccess",
    "${site_path}/typo3conf/.htaccess",
    "${site_path}/typo3conf/ext/.htaccess",
    "${site_path}/uploads/.htaccess"
  ]:
    replace => "no",
    ensure  => "present",
    mode	=> 644,
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
      replace => "no",
      ensure  => "present",
      content => template('typo3/localconf.php.erb'),
      mode    => 644,
      require => File["${site_path}/typo3conf"],
    }

  } elsif $version =~ /^6\./ {

    File {
      replace => "no",
      ensure  => "present",
      mode    => 644,
      owner   => $site_user,
      group   => $site_group
    }

    file { "${site_path}/typo3conf/LocalConfiguration.php":
      content => template('typo3/LocalConfiguration.php.erb'),
    }

    file { "${site_path}/typo3conf/AdditionalConfiguration.php":
      content => template('typo3/AdditionalConfiguration.php.erb'),
    }

    file {[
      "${site_path}/fileadmin/_processed_"
    ]:
      ensure  => "directory",
      mode	=> 755,
      require => File["${site_path}/fileadmin"]
    }

  }
}