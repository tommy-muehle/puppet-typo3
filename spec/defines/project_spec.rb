require 'spec_helper'

describe 'typo3::project', :type => :define do

    let(:title)   { 'test' }
    let(:params)  { {:version => '6.1.3', :site_path => '/var/www/test', :site_user => 'vagrant', :site_group => 'www-data'} }

    it { should contain_typo3__project('test') }
    it { should contain_typo3__install__source('test-6.1.3') }
    it { should contain_typo3__install__source__files('test-6.1.3') }

end