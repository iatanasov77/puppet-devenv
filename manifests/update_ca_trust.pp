class vs_devenv::update_ca_trust (
    Array $caTrustNotify,
) {
    $notifyServices = $caTrustNotify.map |$service| {
        Service[$service]
    }
    
    exec { 'Update_CA_Trust':
        command => 'update-ca-trust extract',
        notify  => $notifyServices,
    }
}
