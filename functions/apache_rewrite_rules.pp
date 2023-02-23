# @summary
#   Return rewrite rules used in apache virtual hosts.
#
#########################################################################
function vs_devenv::apache_rewrite_rules( Boolean $needRewriteRules ) {

    if ( $needRewriteRules ) {
        [
            {
                comment      => 'Standart Rewrite Rules',
                rewrite_base => '/',
                rewrite_rule => ['^index\.html$ - [L]'],
            },
            {
                comment      => 'Application Rewrite Rules',                
                rewrite_cond => ['%{REQUEST_FILENAME} !-f', '%{REQUEST_FILENAME} !-d'],
                rewrite_rule => ['. /index.html [L]'],
            }
        ]
    }
    
}
