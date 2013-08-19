# Puppet module: typo3

This puppet module can be used to easily generate (multiple) typo3 projects.

**Please feel free to give me feedback, feature-requests or new requirements**

## Usage

    typo3::project { 'my-project':
        version => '6.1.3',
        site_path => '/var/www/my-project',
        site_user => 'vagrant',
        site_group => 'www-data'
    }

With a prepared database-connection:

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

## Result

The module generates an easy updatable folder-structure on the basis of the TYPO3 version.

Example for a TYPO3 4.7.10 (v4) project:

    fileadmin/
    fileadmin/.htaccess
    fileadmin/_temp_/
    fileadmin/user_upload/
    typo3conf/.htaccess
    typo3conf/localconf.php
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