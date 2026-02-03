async function decriptRSA(){
    const ris = await fetch("chiave_privata.json");
    const chiave_privata = await ris.json();
    const d = chiave_privata.d;
    const n = chiave_privata.n;
    const c_s = localStorage.getItem("messaggio_cifrato");
    let m_s; //messaggio originale stringa
    for(let i=0; i<mCifrato_S.length; i++){
        m.push(Math.pow(parseInt(c_s[i]), (d%n)));
    }
    let m = deconversionASCII(m_s);
    m = document.getElementById("text").innerHTML;
}
function conversionASCII(text){
    const vet = [];
    for(let i=0; i<text.length; i++){
        vet.push(text.fromCharCode(i));
    }
    return vet;
}