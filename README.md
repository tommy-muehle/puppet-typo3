# Puppet module: typo3

This puppet module can be used to easily generate (multiple) typo3 projects.

**Please feel free to give me feedback, feature-requests or new requirements**

## Install

Just clone the repo in your modules folder.

    # /path/to/modules
    git clone git@github.com:tommy-muehle/puppet-typo3.git typo3

## Usage

### Minimal example 

    typo3::project { 'my-project':
        version => '6.1.3',
        site_path => '/var/www/my-project',
        site_user => 'vagrant',
        site_group => 'www-data'
    }

### With a prepared database-connection:

    typo3::project { 'my-project':
        version => '6.1.3',
        site_path => '/var/www/my-project',
        site_user => 'vagrant',
        site_group => 'www-data',
        db_name => 'typo3_db',
        db_host => 'localhost',
        db_pass => 'secret',
        db_user => 'typo3'
    }

### With pre-installed extensions: 
**(only from their git repository at the time)**  

You can install extensions from their git-repository. Many extensions can be found [here](http://git.typo3.org).
But you can also install your own extensions for example from github.

You need therefor:

* key  
The extension key.

* repo  
The path to the git repo. Be sure that you can passwordless access the repo for cloning.

* tag (optional)  
In most cases an extension version is tagged in the git repository. So you can get an explicit version by setting of this value.
If no tag is set, the last commit from master branch will be checked out.

Here is an example to install realurl in version 1.12.6 and the latest version of phpunit:

    typo3::project { 'my-project':
        version => '6.1.3',
        site_path => '/var/www/my-project',
        site_user => 'vagrant',
        site_group => 'www-data',

        extensions => [
          {"key" => "realurl", "repo" => "git://git.typo3.org/TYPO3v4/Extensions/realurl.git", "tag" => "1_12_6"},
          {"key" => "phpunit", "repo" => "git://git.typo3.org/TYPO3v4/Extensions/phpunit.git"}
        ]
    }

## Result

The module generates an easy updatable folder-structure on the basis of the TYPO3 version.

Example for a TYPO3 4.7.10 (v4) project:

    fileadmin/
    fileadmin/.htaccess
    fileadmin/_temp_/
    fileadmin/user_upload/
    typo3conf/.htaccess
    typo3conf/localconf.php
    typo3conf/extTables.php
    typo3conf/ext/
    typo3conf/ext/.htaccess
    typo3conf/l10n/
    uploads/
    uploads/.htaccess
    uploads/pics/
    uploads/media/
    uploads/tf/
    typo3_src-4.7.10/
    typo3_src -> typo3_src-4.7.10
    index.php -> typo3_src/index.php
    t3lib -> typo3_src/t3lib
    typo3 -> typo3_src/typo3

For a TYPO3 6.1.3 (v6) project:

    fileadmin/
    fileadmin/.htaccess
    fileadmin/_processed_/
    fileadmin/_temp_/
    fileadmin/user_upload/
    typo3conf/.htaccess
    typo3conf/LocalConfiguration.php
    typo3conf/AdditionalConfiguration.php
    typo3conf/extTables.php
    typo3conf/ext/
    typo3conf/ext/.htaccess
    typo3conf/l10n/
    uploads/
    uploads/.htaccess
    uploads/pics/
    uploads/media/
    uploads/tf/
    typo3_src-6.1.3/
    typo3_src -> typo3_src-6.1.3
    index.php -> typo3_src/index.php
    t3lib -> typo3_src/t3lib
    typo3 -> typo3_src/typo3

## ToDo's

* Failure-Handling
* Write tests