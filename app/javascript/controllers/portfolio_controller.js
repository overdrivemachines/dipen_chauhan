import { Controller } from "@hotwired/stimulus";
import { gsap, TimelineMax, Power1 } from "gsap";
import { Flip } from "gsap/Flip";
gsap.registerPlugin(Flip);
export default class extends Controller {
  connect() {
    // Array of ".project-move-actions a" elements
    const projectMoveLinks = gsap.utils.toArray(".project-move-actions a");

    // Loader
    const loader = document.getElementById("loader");

    // Array of "#portfolioCategories .filter" elements
    const portfolioCategoriesEl = gsap.utils.toArray("#portfolioCategories .filter");
    // Array of .portfolio-item elements
    const portfolioItemsEl = gsap.utils.toArray(".portfolio-item");

    // When a portfolio category is clicked call the updateFilters function
    portfolioCategoriesEl.forEach((cat) =>
      cat.addEventListener("click", (e) => {
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
      })
    );

    // When projectMoveLinks are clicked, show the loader
    projectMoveLinks.forEach((link) =>
      link.addEventListener("click", () => {
        loader.style.display = "flex";
      })
    );

    loader.style.display = "none";
  }
}
