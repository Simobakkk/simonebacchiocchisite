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
//CSV Importer - Legge file CSV
async function csvImporter(url) {
  window.location.href = "droneSelection_HP.html";
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
    return data;
}

//XML Importer - Legge file XML
async function xmlImporter(url) {
  window.location.href = "droneSelection_HP.html";
    const response = await fetch(url);
    const text = await response.text();
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(text, 'text/xml');
    const items = xmlDoc.getElementsByTagName('item');
    const data = [];
    
    for (let i = 0; i < items.length; i++) {
        const item = items[i];
        const row = {};
        for (let child of item.children) {
            row[child.tagName] = child.textContent;
        }
        data.push(row);
    }
    return data;
}

//TXT Importer - Legge file TXT
async function txtImporter(url) {
        window.location.href = "droneSelection_HP.html";
        const response = await fetch(url);
        const text = await response.text();
        
        // Converte il TXT in oggetto
        const dati = {};
        text.split('\n').forEach(line => {
            const [key, value] = line.split(':').map(s => s.trim());
            if (key && value) dati[key] = value;
        });
        
        return dati;
    }

//JSON Importer - Legge file JSON
async function jsonImporter(url) {
    window.location.href = "droneSelection_HP.html";
    const response = await fetch(url);
    const data = await response.json();
    return data;
}