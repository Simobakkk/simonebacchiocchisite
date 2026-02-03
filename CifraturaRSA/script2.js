async function decriptRSA(){
    const ris = await fetch("chiave_privata.json");
    const chiave_privata = await ris.json();
    const d = chiave_privata.d;
    const n = chiave_privata.n;
    const c = JSON.parse(localStorage.getItem("messaggio_cifrato"));
    let m = []; //messaggio originale 
    for(let i=0; i<c.length; i++){
        m.push(Math.pow(parseInt(c[i]), d) % n);
    }
    m = deconversionASCII(m);
    m = document.getElementById("text").innerHTML;
}

function deconversionASCII(text){
    const vet = [];
    for(let i=0; i<text.length; i++){
        vet.push(text.fromCharCode(i));
    }
    return vet;
}