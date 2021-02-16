class vs_devenv::sendmail
{
	exec { 'Set Sendmail Spool':
        command => '/usr/bin/mkfifo /var/spool/postfix/public/pickup',
    } ->
    service { 'postfix':
		ensure => running,
		enable => true,
	}
}
