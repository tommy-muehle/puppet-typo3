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
    mode	=> 775
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

    file {[
      "${site_path}/fileadmin/_processed_"
    ]:
      ensure  => "directory",
      owner   => $site_user,
      group   => $site_group,
      mode	=> 775
    }

  }
}