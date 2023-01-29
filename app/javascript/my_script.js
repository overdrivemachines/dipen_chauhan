import { gsap, TimelineMax, Power1 } from "gsap";
import { Flip } from "gsap/Flip";
import CircleType from "circletype";

gsap.registerPlugin(Flip);

// This function runs on every page "load"
document.addEventListener("turbo:load", () => {
  const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
  const popoverList = [...popoverTriggerList].map((popoverTriggerEl) => new bootstrap.Popover(popoverTriggerEl));

  /* ---------------------------------------------
  Circletype
  --------------------------------------------- */
  let CircleTypeText1 = document.getElementById("CircleTypeText1");
  if (CircleTypeText1 != null) {
    new CircleType(CircleTypeText1);
  }

  /* ---------------------------------------------
  My Name Text Effect
  --------------------------------------------- */
  const myNameEl = document.querySelector(".my-name");

  if (myNameEl != null) {
    // Wrap each letter with a span.letter
    myNameEl.innerHTML = myNameEl.innerText.replace(/([^\x00-\x80]|\w)/g, "<span class='letter'>$&</span>");

    // Array of span.letter elements
    const lettersArray = gsap.utils.toArray("span.letter");

    // Create a new timeline
    let myNameTimeline = new TimelineMax({ repeat: -1 });

    myNameTimeline
      .staggerFrom(
        lettersArray,
        0.5,
        {
          top: "+=25px",
          rotation: "-=-3deg",
          alpha: 0,
          scale: 0.8,
          ease: Power1.easeOut,
        },
        0.15
      )
      .to(lettersArray, 0.5, { alpha: 0, ease: Power1.easeOut }, "+=1.2");
  }
});

/* ---------------------------------------------
Mobile-menu
--------------------------------------------- */
const burger = document.querySelector(".mobile-menu-btn");
const nav = document.querySelector(".main-nav-js");
const navLinks = document.querySelectorAll(".main-nav-js .menu-list .menu-item");
const miLinks = gsap.utils.toArray(".mi-link");

const menuCloseBtn = document.querySelector(".menu-close-btn");

function addAnimationToNavLinks() {
  navLinks.forEach((link, index) => {
    if (link.style.animation) {
      link.style.animation = "";
    } else {
      link.style.animation = `navLinkFade 0.4s ease forwards ${index / 10 + 0.5}s `;
    }
  });
}

function hideMenu() {
  nav.classList.remove("show-menu");
  addAnimationToNavLinks();
}

// When the burger button is clicked, show the menu and add animation to the nav links
burger.addEventListener("click", () => {
  nav.classList.add("show-menu");
  addAnimationToNavLinks();
  // burger.classList.toggle("toggle");
});

// When the close button is clicked, hide the menu and add animation to the nav links
menuCloseBtn.addEventListener("click", () => {
  hideMenu();
  // burger.classList.toggle("toggle");
});

// When the menu links are clicked, hide the menu and add animation to the nav links
miLinks.forEach((m) => {
  m.addEventListener("click", () => {
    hideMenu();
  });
});

/* ---------------------------------------------
Portfolio Filter
--------------------------------------------- */

// Array of "#portfolioCategories .filter" elements
const portfolioCategoriesEl = gsap.utils.toArray("#portfolioCategories .filter");
// Array of .portfolio-item elements
const portfolioItemsEl = gsap.utils.toArray(".portfolio-item");

function updateFilters(e) {
  // capture the current state of portfolioItemsEl
  const itemsState = Flip.getState(portfolioItemsEl);

  // capture the current state of the .portfolio-item's parent
  const containerState = Flip.getState(".portfolio-item-container");

  //
  let selectedCategoryEl = e.target;

  // check if e.target is span element
  if (selectedCategoryEl.tagName == "SPAN") {
    // set selectedCategoryEl to the parent element which is a li.filter element
    selectedCategoryEl = selectedCategoryEl.parentElement;
  }

  // remove the .active class from all .filter elements
  portfolioCategoriesEl.forEach((cat) => cat.classList.remove("active"));

  // add the .active class for the element that was clicked
  selectedCategoryEl.classList.add("active");

  // get the category that was clicked e.g. rails or javascript
  const selectedCategory = selectedCategoryEl.dataset.filter;

  if (selectedCategory == "*") {
    // display all items
    portfolioItemsEl.forEach((i) => (i.style.display = "block"));
  } else {
    // display only items that match
    portfolioItemsEl.forEach((i) => (i.style.display = i.dataset.category == selectedCategory ? "block" : "none"));
  }

  // Animate .portfolio-item elements from the previous state
  Flip.from(itemsState, {
    duration: 1,
    scale: true,
    ease: "power1.inOut",
    onEnter: (elements) => gsap.fromTo(elements, { opacity: 0, scale: 0 }, { opacity: 1, scale: 1, duration: 1 }),
    onLeave: (elements) => gsap.to(elements, { opacity: 0, scale: 0, duration: 1 }),
  });

  // Animate .portfolio-item-container elements from the previous state
  Flip.from(containerState, {
    duration: 1,
    ease: "power1.inOut",
  });
}

gsap.from(".portfolio-item", {
  duration: 2,
  scale: 0.8,
  opacity: 0,
  delay: 0.5,
  stagger: 0.2,
  ease: "elastic",
  force3D: true,
});

// When a portfolio category is clicked call the updateFilters function
portfolioCategoriesEl.forEach((cat) => cat.addEventListener("click", updateFilters));
