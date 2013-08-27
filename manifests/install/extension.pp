# = Class: typo3::install::extension
#
# == Parameters
#
# Standard class parameters
#
# [*key*]
#   The extension key
#   Example: 'realurl'
#
# [*repo*]
#   The url for git-repository
#   Example: 'git://git.typo3.org/TYPO3v4/Extensions/realurl.git'
#
# [*tag*]
#   The git tag
#   Example: '1_12_6'
#
# == Author
# Tommy Muehle
#
define typo3::install::extension (

  $key = $name["key"],
  $repo = $name["repo"],
  $tag = $name["tag"],
  $path,
  $owner,
  $group

) {

  if $tag == "" or $tag == undef {
    $tag_name = "master"
  }

  exec {"git-clone ${key}":
    command     => "git clone --no-hardlinks ${repo} ${key}",
    creates     => "${path}/${key}/.git",
    cwd         => $path,
    onlyif      => "test ! -d ${path}/${key}",
    require     => Package[$typo3::packages],
  }

  exec {"git-checkout ${key} ${version}":
    command     => "git checkout ${tag_name}",
    cwd         => "${path}/${key}",
    notify      => Exec["chown ${key}"],
    require     => Exec["git-clone ${key}"]
  }

  exec {"chown ${key}":
    command     => "chown -R ${owner}:${group} ${path}/${key}",
    refreshonly => true,
    cwd         => $path,
    require     => Exec["git-clone ${key}"]
  }

}