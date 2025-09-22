// Generar pétalos en la portada
document.addEventListener("DOMContentLoaded", () => {
  const root = document.querySelector(".petals");
  if (!root) return;

  const total = 20;
  for (let i = 0; i < total; i++) {
    const petal = document.createElement("span");

    const size = 6 + Math.random() * 10;
    petal.style.width = size + "px";
    petal.style.height = size + "px";
    petal.style.left = Math.random() * 100 + "vw";
    petal.style.animationDuration = 5 + Math.random() * 5 + "s";
    petal.style.animationDelay = Math.random() * 5 + "s";

    root.appendChild(petal);
  }
});