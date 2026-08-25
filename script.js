const body = document.body;
const intro = document.querySelector('.scroll-intro');
const menuButton = document.querySelector('.menu-toggle');
const nav = document.querySelector('.site-header nav');

const finishIntro = () => body.classList.remove('is-opening');
intro?.addEventListener('animationend', (event) => {
  if (event.animationName === 'introGone') finishIntro();
});
window.setTimeout(finishIntro, 2450);

menuButton?.addEventListener('click', () => {
  const open = nav.classList.toggle('open');
  menuButton.setAttribute('aria-expanded', String(open));
});
nav?.querySelectorAll('a').forEach((link) => link.addEventListener('click', () => {
  nav.classList.remove('open');
  menuButton?.setAttribute('aria-expanded', 'false');
}));
