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
