# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# From "jquery-rails" gem
# pin "jquery", to: "jquery3.min.js", preload: true
# pin "jquery_ujs", to: "jquery_ujs.js", preload: true

# From "bootstrap" gem
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true

# GSAP Core and GSAP Flip plugin
pin "gsap", to: "https://ga.jspm.io/npm:gsap@3.11.4/index.js", preload: true
pin "gsap/Flip", to: "https://ga.jspm.io/npm:gsap@3.11.4/Flip.js", preload: true

# Circletype
pin "circletype", to: "https://ga.jspm.io/npm:circletype@2.3.0/dist/circletype.min.js", preload: true

# Custom JS
pin "my_script", to: "my_script.js"
