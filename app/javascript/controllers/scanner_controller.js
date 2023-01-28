import { Controller } from "@hotwired/stimulus"
import { BrowserMultiFormatReader,NotFoundException } from '@zxing/library';

// Connects to data-controller="scanner"
export default class extends Controller {
  static values = { groceryUrl: String }
  static targets = [ 'barcode', 'ingredient']

  connect() {
    this.codeReader = new BrowserMultiFormatReader();
  }

  startScanning() {
    this.codeReader.listVideoInputDevices().then((videoInputDevices) => {
      const selectedDeviceId = videoInputDevices[0].deviceId
      this.codeReader.decodeFromVideoDevice(selectedDeviceId, 'video', (result, err) => {
        if (result) {
          this.fetchGrocery(result.text)
        }
        if (err && !(err instanceof NotFoundException)) {
          console.error(err)
        }
      })
    })
    .catch((err) => {
      console.error(err)
    })
  }

  stopScanning() {
    this.codeReader.stopStreams()
  }

  fetchGrocery(barcode) {
    var csrf = document.querySelector('meta[name="csrf-token"]').content;
    fetch(`${this.groceryUrlValue}.json`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrf
      },
      body: JSON.stringify({grocery: { barcode: barcode} } )
    })
    .then(response => {
      if(response.status == 200 || response.status == 201){
        return response.json()
      }
      throw "Error fetching data for barcode";
    })
    .then(data => {
      this.stopScanning()
      this.application.getControllerForElementAndIdentifier(this.barcodeTarget, 'modal').close()
      this.ingredientTarget.click()
      document.getElementById('ingredient_grocery_attributes_name').value = data.name
      document.getElementById('ingredient_grocery_id').value = data.id
    })
    .catch(err => {
      this.stopScanning()
      this.application.getControllerForElementAndIdentifier(this.barcodeTarget, 'modal').close()
      const el = document.createElement('div');
      el.classList.add('notice', 'notice-warning');
      el.textContent = err
      document.getElementById("flash").appendChild(el)
    });
  }
}
