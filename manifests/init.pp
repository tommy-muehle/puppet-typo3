# = Class: typo3
#
# This is the main typo3 class
#
#
# == Parameters
#
# Standard class parameters
#
# [*project*]
#
# [*version*]
#
# [*site_path*]
#
# == Author
# Tommy Muehle
#
class typo3 (
  	$project   	 = params_lookup( 'project' ),
  	$version  	 = params_lookup( 'version' ),
  	$site_path	 = params_lookup( 'site_path' ),
  	
  	$source_dir  = "/usr/share/typo3"
  	
) {

	

}