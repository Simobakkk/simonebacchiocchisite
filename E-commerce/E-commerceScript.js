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
    try {
        const response = await fetch(url);
        const text = await response.text();
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(text, 'text/xml');
        const items = xmlDoc.getElementsByTagName('drone');
        const result = [];
        
        for (let i = 0; i < items.length; i++) {
            const item = items[i];
            const drone = {};
            
            for (let child of item.children) {
                drone[child.tagName] = child.textContent;
            }
            
            result.push(drone);
        }

        window.location.href = "droneSelection_HP.html";
        return result;
    } catch (error) {
        console.error('Errore XML:', error);
        return [];
    }
}

// TXT Importer
async function txtImporter(url) {
    const response = await fetch(url);
    const text = await response.text();
    
    const droni = [];
    const blocchi = text.split('\n\n');
    
    blocchi.forEach(blocco => {
        const drone = {};
        const righe = blocco.split('\n');
        
        righe.forEach(riga => {
            const colonna = riga.indexOf(':');
            if (colonna > -1) {
                const chiave = riga.slice(0, colonna).trim();
                const valore = riga.slice(colonna + 1).trim();
                drone[chiave] = valore;
            }
        });
        
        if (Object.keys(drone).length) droni.push(drone);
    });
    
    window.location.href = "droneSelection_HP.html";
    return droni;
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
    
    if (!droniDaMostrare || droniDaMostrare.length === 0) {
        container.innerHTML = '<div class="no-results">Nessun drone trovato</div>';
        return;
    }
    
    container.innerHTML = droniDaMostrare.map((drone, index) => {
        const nome = drone.nome || drone.Nome || drone.name || 'Senza nome';
        const modello = drone.modello || drone.Modello || '';
        const prezzo = drone.prezzo || drone.Prezzo || '0';
        
        return `
        <div class="droni-grid">
            <div class="drone-card" style="animation-delay: ${index * 0.05}s">
                <div class="drone-card-inner">
                    <div class="drone-image">
                        <div class="image-placeholder"><img src="https://static.bhphotovideo.com/explora/sites/default/files/dji_mavic_pro_mavic_1.jpg" width="100%"></div>
                        <div class="drone-badge">${parseInt(prezzo) > 5000 ? 'Premium' : 'Standard'}</div>
                    </div>
                    <div class="drone-info">
                        <h3 class="drone-name">${nome}</h3>
                        <p class="drone-model">${modello}</p>
                        <div class="drone-price">
                            <span class="price-currency">€</span>
                            <span class="price-value">${parseInt(prezzo).toLocaleString()}</span>
                            <span class="price-period">.00</span>
                        </div>
                        <div class="drone-actions">
                            <button class="btn-details" onclick="apriDettagli(${JSON.stringify(drone).replace(/"/g, '&quot;')})">
                                Dettagli
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M5 12h14M12 5l7 7-7 7"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
          </div>
        `;
    }).join('');
}

function filtraDroni() {
    const testo = document.getElementById('search-input').value.toLowerCase();
    const filtrati = droniFiltrati.filter(d => {
        const nome = (d.nome || d.Nome || '').toLowerCase();
        return nome.includes(testo);
    });
    mostraTutti(filtrati);
}

const searchInput = document.getElementById('search-input');
if (searchInput) {
    searchInput.addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            filtraDroni();
        }
    });
}