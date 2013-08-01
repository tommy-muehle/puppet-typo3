# = Class: typo3::source
#
# == Parameters
#
# Standard class parameters
#
# [*site*]
#
# [*cwd*]
#
# == Author
# Tommy Muehle
#
define typo3::source (
        $site="get.typo3.org",
        $cwd="",
        $creates="",
        $require="",
        $user="") {                                                                                         

    exec { $name:                                                                                                                     
        command => "wget ${site}/${name} -O ${name}.tar.gz",                                                         
        cwd => $cwd,
        creates => "${cwd}/${name}",                                                              
        require => $require,
        user => $user,                                                                                                          
    }

}