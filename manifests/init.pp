# = Class: typo3
#
# This is the main typo3 class
#
# == Author
# Tommy Muehle
#
class typo3 (){

  if $::operatingsystem =~ /^(Debian|Ubuntu)$/ and versioncmp($::operatingsystemrelease, "12") < 0 {
    $packages = [ "wget", "git-core" ]
  } else {
    $packages = [ "wget", "git" ]
  }

  safepackage { $packages: ensure => "installed" }
	
}

define safepackage ( $ensure = installed ) {

  if !defined(Package[$title]) {
    package { $title: ensure => $ensure }
  }

}