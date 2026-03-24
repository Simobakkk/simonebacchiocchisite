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

async function criptRSA() {
    const text = document.getElementById("text").value;
    const textASCII = conversionASCII(text);
    console.log(textASCII);

    const ris = await fetch("chiavi_pubbliche.json");
    const chiave_pubblica = await ris.json();
    const e = Number(chiave_pubblica.e);
    const n = Number(chiave_pubblica.n);

    let c = [];
    for (let i = 0; i < textASCII.length; i++) {
        c.push(modExp(textASCII[i], e, n));
    }

    localStorage.setItem("messaggio_cifrato", JSON.stringify(c));
    window.location.href = "decifraturaRSA.html";
}

function conversionASCII(text) {
    const vet = [];
    for (let i = 0; i < text.length; i++) {
        vet.push(text.charCodeAt(i));
    }
    return vet;
}


