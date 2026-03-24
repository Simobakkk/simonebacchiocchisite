<?php

class Conversione {

    // cm → pollici
    public function cmToPollici($cm) {
        return $cm * 0.393701;
    }

    // pollici → cm
    public function polliciToCm($pollici) {
        return $pollici * 2.54;
    }
}

ini_set("soap.wsdl_cache_enabled", "0");

$server = new SoapServer("test.wsdl");
$server->setClass("Conversione");
$server->handle();

?>

