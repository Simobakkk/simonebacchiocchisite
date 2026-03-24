// Stampa il messaggio criptato dopo il caricamento della pagina
document.addEventListener("DOMContentLoaded", function() {
    const messaggioCifrato = JSON.parse(localStorage.getItem("messaggio_cifrato"));
    document.getElementById("messaggioCifrato").innerHTML = messaggioCifrato.join("");
});

// Funzione per esponenziazione modulare (base^exp % mod)
function modExp(base, exp, mod) {
    let result = 1;
    base = base % mod;
    while (exp > 0) {
        if (exp % 2 === 1) {
            result = (result * base) % mod;
        }
        base = (base * base) % mod;
        exp = Math.floor(exp / 2);
    }
    return result;
}

async function decriptRSA() {
    const ris = await fetch("chiave_privata.json");
    const chiave_privata = await ris.json();
    const d = Number(chiave_privata.d);
    const n = Number(chiave_privata.n);

    const c = JSON.parse(localStorage.getItem("messaggio_cifrato"));

    let m = [];
    for (let i = 0; i < c.length; i++) {
        m.push(modExp(parseInt(c[i]), d, n));
    }
    m = deconversionASCII(m);

    // mostra il messaggio nel DOM
    document.getElementById("text").innerHTML = m;
}

function deconversionASCII(text) {
    const vet = [];
    for (let i = 0; i < text.length; i++) {
        vet.push(String.fromCharCode(text[i]));
    }
    return vet.join("");
}