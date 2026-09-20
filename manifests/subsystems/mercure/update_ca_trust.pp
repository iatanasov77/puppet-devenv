class vs_devenv::subsystems::mercure::update_ca_trust (
    Array $caTrustNotify,
) {
    $notifyServices = $caTrustNotify.map |$service| {
        Service[$service]
    }
    
    exec { 'Update_CA_Trust_MercureHub':
        command => 'update-ca-trust extract',
        notify  => $notifyServices,
    }
}
