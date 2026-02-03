async function criptRSA(){
    const text = document.getElementById("text").value;
    const textASCII =  conversionASCII(text);
    console.log(textASCII);
    const ris = await fetch("chiavi_pubbliche.json"); //chiamata HTTP 
    const chiave_pubblica = await ris.json(); // risposta convertita in JSON
    const e = chiave_pubblica.e;
    const n = chiave_pubblica.n;
    let cStringa; //messaggio cifrato
    for(let i=0; i<textASCII.length; i++){
        cStringa.push(Math.pow(textASCII[i], (e%n))+" "); 
    }
    localStorage.setItem("messaggio_cifrato", cStringa);
    window.location.href = "decifraturaRSA.html";
}

function conversionASCII(text){
    const vet = [];
    for(let i=0; i<text.length; i++){
        vet.push(text.charCodeAt(i));
    }
    return vet;
}


