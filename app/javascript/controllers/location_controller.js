import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["addressField"]

  connect() {
    console.log("Location controller initialized")
    // Initial check on page load
    const select = this.element.querySelector('select')
    if (select) {
      this.toggleAddress({ target: select })
    }
  }

  toggleAddress(event) {
    const locationType = event.target.value
    console.log("Toggling address for:", locationType)
    
    if (locationType === "physical") {
      this.addressFieldTarget.style.display = "block"
    } else {
      this.addressFieldTarget.style.display = "none"
      this.addressFieldTarget.querySelector('input').value = ''
    }
  }
}