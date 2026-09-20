class vs_devenv::subsystems::websocket::update_ca_trust (
    Array $caTrustNotify,
) {
    $notifyServices = $caTrustNotify.map |$service| {
        Service[$service]
    }
    
    exec { 'Update_CA_Trust_WebsocketServer':
        command => 'update-ca-trust extract',
        notify  => $notifyServices,
    }
}
