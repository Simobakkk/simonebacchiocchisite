<!DOCTYPE html>
<html>
<head>
    <title>Conversione cm ↔ pollici</title>
    <link rel="stylesheet" href="style.css">
</head>
    <body>
        <div class="container">

            <h2>Conversione cm ↔ pollici</h2>

            <form method="POST">

                <label>Inserisci valore numerico:</label>
                <input type="number" step="any" name="valore" required>

                <label>Seleziona unità di partenza:</label>
                <select name="unita">
                    <option value="cm">Centimetri</option>
                    <option value="pollici">Pollici</option>
                </select>

                <input type="submit" value="Converti">

            </form>

        </div>
    </body>
</html>


<?php
ini_set("soap.wsdl_cache_enabled", "0");

$risultato = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $valore = floatval($_POST["valore"]);
    $unita = $_POST["unita"];

    try {

        $client = new SoapClient(
            "https://simonebacchiocchi.infinityfreeapp.com/test.wsdl"
        );

        if ($unita == "cm") {
            $conversione = $client->cmToPollici($valore);
            $risultato = $valore . " cm = " . $conversione . " pollici";
        } else {
            $conversione = $client->polliciToCm($valore);
            $risultato = $valore . " pollici = " . $conversione . " cm";
        }

    } catch (Exception $e) {
        $risultato = "Errore: " . $e->getMessage();
    }
}
?>