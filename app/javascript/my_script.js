// Test if jquery is loaded by typing $.fn.jquery in the console as per
// https://stackoverflow.com/questions/6973941/how-to-check-what-version-of-jquery-is-loaded/26674265#26674265

const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl))
