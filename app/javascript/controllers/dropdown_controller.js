import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
	static targets = ["content"]
  	connect() {
		this.close()
  	}

	closeOnBigScreen(event) {
		if (window.innerWidth > 768) {
			this.close()
		}
	}

	toggle() {
		if (this.contentTarget.classList.contains('hidden')) {
			this.open()
		} else {
			this.close()
		}
	}

	open() {
		this.contentTarget.classList.remove('hidden')
		let main = document.querySelector('main')
		main.classList.add('blur')
		document.body.classList.add('overflow-hidden')
	}

	close() {
		this.contentTarget.classList.add('hidden')
		let main = document.querySelector('main')
		main.classList.remove('blur')
		document.body.classList.remove('overflow-hidden')
	}
}
