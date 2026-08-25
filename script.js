const body = document.body;
const intro = document.querySelector('.scroll-intro');
const menuButton = document.querySelector('.menu-toggle');
const nav = document.querySelector('.site-header nav');
const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

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

const revealTargets = document.querySelectorAll(
  '.section .section-heading, .section .about-copy, .education-list, .interest-list, .publication-list, .activity-list'
);

revealTargets.forEach((target) => {
  target.classList.add('ink-reveal');
  if (!target.classList.contains('section-heading')) target.classList.add('ink-reveal-late');
});

if (reduceMotion || !('IntersectionObserver' in window)) {
  revealTargets.forEach((target) => target.classList.add('is-visible'));
} else {
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add('is-visible');
      revealObserver.unobserve(entry.target);
    });
  }, { rootMargin: '0px 0px -10% 0px', threshold: 0.08 });
  revealTargets.forEach((target) => revealObserver.observe(target));
}

const contactSection = document.querySelector('#contact');
const emailCopy = document.querySelector('.email-copy');
const copyFeedback = document.querySelector('.copy-feedback');
let copyFeedbackTimer = null;
let rippleTimer = null;
let lastRippleAt = 0;

const animateContactRipple = () => {
  if (!contactSection || reduceMotion) return;
  window.clearTimeout(rippleTimer);
  contactSection.classList.remove('is-rippling');
  void contactSection.offsetWidth;
  contactSection.classList.add('is-rippling');
  rippleTimer = window.setTimeout(() => contactSection.classList.remove('is-rippling'), 1900);
};

const fallbackCopy = (text) => {
  const field = document.createElement('textarea');
  field.value = text;
  field.setAttribute('readonly', '');
  field.style.position = 'fixed';
  field.style.opacity = '0';
  document.body.appendChild(field);
  field.select();
  const copied = document.execCommand('copy');
  field.remove();
  return copied;
};

emailCopy?.addEventListener('pointerenter', () => {
  const now = Date.now();
  if (now - lastRippleAt < 1800) return;
  lastRippleAt = now;
  animateContactRipple();
});

emailCopy?.addEventListener('click', async (event) => {
  event.preventDefault();
  const email = emailCopy.dataset.email || emailCopy.textContent.trim();
  let copied = false;
  try {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(email);
      copied = true;
    } else {
      copied = fallbackCopy(email);
    }
  } catch {
    copied = fallbackCopy(email);
  }

  window.clearTimeout(copyFeedbackTimer);
  copyFeedback.textContent = copied ? 'COPIED' : 'COPY MANUALLY';
  copyFeedback.parentElement.classList.toggle('is-copied', copied);
  animateContactRipple();
  copyFeedbackTimer = window.setTimeout(() => {
    copyFeedback.textContent = 'CLICK TO COPY';
    copyFeedback.parentElement.classList.remove('is-copied');
  }, 1800);
});
