import { StreamActions } from '@hotwired/turbo'

StreamActions.dispatch_event = function() {
  const member = this.getAttribute('member')
  const event = new Event(member)
  window.dispatchEvent(event)
  // If you want to send the event somewhere besides the window
  // document.getElementById(this.target).dispatchEvent(event) 
}
