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

  typo3::install { "${name}-${version}":
    version => $version,
    cwd	   	=> $site_path
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
    owner   => $site_user,
    group   => $site_group,
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
    owner   => $site_user,
    group   => $site_group,
    content => template('typo3/.htaccess.erb'),
    require => [
      File["${site_path}/fileadmin"],
      File["${site_path}/typo3conf"],
      File["${site_path}/typo3conf/ext"],
      File["${site_path}/uploads"]
    ]
  }

  file { "${site_path}/typo3_src":
    ensure 	=> "link",
    owner  	=> $site_user,
    group  	=> $site_group,
    target 	=> "typo3_src-${version}",
    require => Typo3::Install["${name}-${version}"]
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