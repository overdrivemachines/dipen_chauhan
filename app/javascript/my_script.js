import { gsap, TimelineMax, Power1 } from "gsap";
import { Flip } from "gsap/Flip";
import CircleType from "circletype";

gsap.registerPlugin(Flip);

// This function runs on every page "load"
document.addEventListener("turbo:load", () => {
  const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
  const popoverList = [...popoverTriggerList].map((popoverTriggerEl) => new bootstrap.Popover(popoverTriggerEl));

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

  /* ---------------------------------------------
  Mobile-menu
  --------------------------------------------- */
  const burger = document.querySelector(".mobile-menu-btn");
  const nav = document.querySelector(".main-nav-js");
  const menuItems = document.querySelectorAll(".main-nav-js .menu-list .menu-item");
  const miLinks = gsap.utils.toArray(".mi-link");

  const menuCloseBtn = document.querySelector(".menu-close-btn");

  function addAnimationToMenuItems() {
    menuItems.forEach((menuItem, index) => {
      if (menuItem.style.animation) {
        menuItem.style.animation = "";
      } else {
        menuItem.style.animation = `navLinkFade 0.4s ease forwards ${index / 10 + 0.5}s `;
      }
    });
  }

  function hideMenu() {
    nav.classList.remove("show-menu");
    addAnimationToMenuItems();
  }

  // When the burger button is clicked, show the menu and add animation to the nav links
  burger.addEventListener("click", () => {
    nav.classList.add("show-menu");
    addAnimationToMenuItems();
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
  Return to Top Button
  --------------------------------------------- */
  const returnToTopBtn = document.getElementById("return-to-top");

  function scrollFunction() {
    if (document.body.scrollTop > 520 || document.documentElement.scrollTop > 520) {
      returnToTopBtn.style.display = "block";
    } else {
      returnToTopBtn.style.display = "none";
    }
  }

  // When the user scrolls down 520px from the top of the document, show the button
  window.onscroll = function () {
    scrollFunction();
  };

  // When the user clicks on the button, scroll to the top of the document
  function returnToTop() {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
  }

  window.returnToTop = returnToTop;

  /* ---------------------------------------------
  Loader
  --------------------------------------------- */
  const loader = document.getElementById("loader");
  loader.style.display = "none";
});

/* ---------------------------------------------
Circletype
--------------------------------------------- */
let CircleTypeText1 = document.getElementById("CircleTypeText1");
if (CircleTypeText1 != null) {
  new CircleType(CircleTypeText1);
}

/* ---------------------------------------------
Portfolio Filter
--------------------------------------------- */
// Moved to portfolio_controller.js
