async function criptRSA(){
    const text = document.getElementById("text").value;
    const textASCII =  conversionASCII(text);
    console.log(textASCII);
    const ris = await fetch("chiavi_pubbliche.json"); //chiamata HTTP 
    const chiave_pubblica = await ris.json(); // risposta convertita in JSON
    const e = chiave_pubblica.e;
    const n = chiave_pubblica.n;
    let c = []; //messaggio cifrato
    for(let i=0; i<textASCII.length; i++){
        c.push(Math.pow(textASCII[i], e) % n); 
    }
    localStorage.setItem("messaggio_cifrato", JSON.stringify(c));
    window.location.href = "decifraturaRSA.html";
}

function conversionASCII(text){
    const vet = [];
    for(let i=0; i<text.length; i++){
        vet.push(text.charCodeAt(i));
    }
    return vet;
}


