async function decriptRSA(){
    const ris = await fetch("chiave_privata.json");
    const chiave_privata = await ris.json();
    const d = chiave_privata.d;
    const n = chiave_privata.n;
    const cStringa = localStorage.getItem("messaggio_cifrato");
    let m; //messaggio originale 
    for(let i=0; i<mCifrato_S.length; i++){
        m.push(Math.pow(parseInt(cStringa[i]), d) % n);
    }
    m = deconversionASCII(m_s);
    m = document.getElementById("text").innerHTML;
}

function deconversionASCII(text){
    const vet = [];
    for(let i=0; i<text.length; i++){
        vet.push(text.fromCharCode(i));
    }
    return vet;
}