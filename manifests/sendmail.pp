class vs_devenv::sendmail
{
	$file_path		= '/var/spool/postfix/public/pickup'
	$file_exists	= find_file( $file_path )
	if ( ! $file_exists ) {
		exec { 'Set Sendmail Spool':
	        command => "/usr/bin/mkfifo ${file_path}",
	    }
	}
	
    service { 'postfix':
		ensure => running,
		enable => true,
	}
}
