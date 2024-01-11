class vs_devenv::final_fixes (
    Hash $subsystems    = {},
    Hash $finalFixes    = {},
) {
    if ( 'tomcat' in $subsystems and $subsystems['tomcat']['enabled'] ) {
        // Do Nothing
        // Module 'vs_java' will Decide What Java Version Should Be Default
    } else {
        Exec{ "Set Java Default ${finalFixes['defaultJava']}":
            command => "/opt/vs_devenv/set_default_java.sh ${finalFixes['defaultJava']}",
        }
    }
}