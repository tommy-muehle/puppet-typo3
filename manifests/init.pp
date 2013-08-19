# = Class: typo3
#
# This is the main typo3 class
#
# == Author
# Tommy Muehle
#
class typo3 (){
	
  if ! defined(Package['wget']) {
    package { 'wget': ensure => 'installed' }
  }
	
}