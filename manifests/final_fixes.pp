class vs_devenv::final_fixes (
    Hash $subsystems    = {},
    Hash $finalFixes    = {},
) {
    /*  Inside If Block Had Problem Before
    Exec{ "Set Java Default ${finalFixes['defaultJava']}":
        command => "/opt/vs_devenv/set_default_java.sh ${finalFixes['defaultJava']}",
    }
    */
    
    if ( 'tomcat' in $subsystems and $subsystems['tomcat']['enabled'] ) {
        /* Do Nothing */
        notice( "Module 'vs_java' will Decide What Java Version Should Be Default." )
    } else {
        notice( "Set Java Default ${finalFixes['defaultJava']}" )
        Exec{ "Set Java Default ${finalFixes['defaultJava']}":
            command => "/opt/vs_devenv/set_default_java.sh ${finalFixes['defaultJava']}",
        }
    }
}