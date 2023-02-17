import { Controller } from "@hotwired/stimulus";
import CircleType from "circletype";

// Connects to data-controller="home" in _banner.html.erb
export default class extends Controller {
  connect() {
    const circleTypeText = document.getElementById("CircleTypeText1");
    if (circleTypeText != null) {
      new CircleType(circleTypeText);
    }
  }
}
