function animateCounter(element, start, end, duration) {
  const startTime = performance.now();

  function update(now) {
    const progress = Math.min((now - startTime) / duration, 1);
    const value = Math.floor(start + (end - start) * progress);
    element.textContent = value;

    if (progress < 1) {
      requestAnimationFrame(update);
    }
  }

  requestAnimationFrame(update);
}

/*greeting*/
document.getElementById("greeting").textContent = localStorage.getItem("name");

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('show');

      if (entry.target.classList.contains("counter")) {
        const el = entry.target;
        const endValue = parseInt(el.dataset.target, 10);
        animateCounter(el, 0, endValue, 2000);
        observer.unobserve(el);
      }
    }
  });
});

document.querySelectorAll(".counter").forEach(el => observer.observe(el));
document.querySelectorAll('.hidden-element').forEach(el => observer.observe(el));

const hamburger = document.querySelector('.hamburger');
const navLinks = document.querySelector('nav ul');

hamburger.addEventListener('click', () => {
  navLinks.classList.toggle('active');
});

/*lettura file*/
// CSV Importer
async function csvImporter(url) {
    const response = await fetch(url);
    const text = await response.text();
    const lines = text.trim().split('\n');
    const headers = lines[0].split(',');
    const data = [];
    
    for (let i = 1; i < lines.length; i++) {
        const values = lines[i].split(',');
        const row = {};
        headers.forEach((header, index) => {
            row[header.trim()] = values[index]?.trim() || '';
        });
        data.push(row);
    }
    
    window.location.href = "droneSelection_HP.html";
    return data;
}

// XML Importer
async function xmlImporter(url) {
    const response = await fetch(url);
    const text = await response.text();
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(text, 'text/xml');
    const items = xmlDoc.getElementsByTagName('droni');
    const data = [];
    
    for (let i = 0; i < items.length; i++) {
        const item = items[i];
        const row = {};
        for (let child of item.children) {
            row[child.tagName] = child.textContent;
        }
        data.push(row);
    }
    
    window.location.href = "droneSelection_HP.html";
    return data;
}

// TXT Importer
async function txtImporter(url) {
    const response = await fetch(url);
    const text = await response.text();
    
    // Converte il TXT in oggetto
    const data = {};
    text.split('\n').forEach(line => {
        const [key, value] = line.split(':').map(s => s.trim());
        if (key && value) data[key] = value; 
    });
    
    window.location.href = "droneSelection_HP.html";
    return [data];  // Restituisce array per uniformità con gli altri
}

// JSON Importer
async function jsonImporter(url) {
    const response = await fetch(url);
    const data = await response.json();
    
    window.location.href = "droneSelection_HP.html";
    return data.droni;
}

// Filtra i droni in base alla ricerca
let droniFiltrati = [];
    
// Carica i droni dal localStorage
function caricaDroni() {
    const salvati = localStorage.getItem('droni');
    if (salvati) {
        droniFiltrati = JSON.parse(salvati);
        mostraTutti(droniFiltrati);
    } else {
        document.getElementById('droniContainer').innerHTML = 'Nessun drone caricato';
    }
}

function mostraTutti(droniDaMostrare) {

    const container = document.getElementById('droniContainer');
            
    if (droniDaMostrare.length === 0) {
        container.innerHTML = '<div class="no-results">Nessun drone trovato</div>';
        return;
    }
    container.innerHTML = droniDaMostrare.map(d => {
        const nome = d.nome || d.Nome || 'Senza nome';
        const modello = d.modello || d.Modello || '';
        const prezzo = d.prezzo || d.Prezzo || '0';
        
        return `
            <div class="drone-card">
                <div class="drone-image">✈️</div>
                <div>
                    <div class="drone-name">${nome}</div>
                    <div>${modello}</div>
                    <div class="drone-price">€ ${parseInt(prezzo).toLocaleString()}</div>
                </div>
            </div>
        `;
    }).join('');
}

function filtraDroni() {
    const testo = document.getElementById('search-input').value.toLowerCase();
    const filtrati = droni.filter(d => {
        const nome = (d.nome || d.Nome || '').toLowerCase();
        return nome.includes(testo);
    });
    mostraDroni(filtrati);
}

// Aggiungi evento per la ricerca
document.getElementById('search-input').addEventListener('input', filtraDroni());