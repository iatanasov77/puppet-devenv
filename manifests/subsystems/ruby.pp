class vs_devenv::subsystems::ruby (
	Hash $config    = {},
) {
	$dependencies	= ['which','gcc','gcc-c++','make','gettext-devel','expat-devel','zlib-devel','openssl-devel',
						'perl','cpio','bzip2','libxml2','libxml2-devel','libxslt','libxslt-devel',
				  		'readline-devel','patch','libyaml-devel','libffi-devel','libtool','bison']

  	Package { $dependencies:
        ensure => present,
    } ->
    Exec { 'Import GPG2 Key for RVM':
      command => "/usr/bin/command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -",
    } ->
    class { '::rvm':
    	#version		=> '1.29.12',
    	gnupg_key_id	=> false,
    	system_users	=> ['vagrant'],
    }
    
    $config['virtual_environments'].each |String $venvId, Hash $venvConfig| {
    	rvm_system_ruby {
			"ruby-${venvConfig['rubyVersion']}":
			    ensure      => 'present',
			    default_use => $venvConfig['defaultUse'];
		}
		
		$venvConfig['packages'].each |String $package| {
    		rvm_gem {
				"${package}":
					name         => "${package}",
					ruby_version => "ruby-${venvConfig['rubyVersion']}",
					ensure       => latest,
					require      => Rvm_system_ruby["ruby-${venvConfig['rubyVersion']}"];
			}
    	}
    }
}
