import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="avatar-preview"
export default class extends Controller {
    static targets = ["input", "image", "edit", "check", "trash", "label"]

    connect() {
        this.hideElement(this.checkTarget);
        this.hideElement(this.trashTarget);
        this.hideElement(this.labelTarget);

        this.isEditMode = false;

        document.addEventListener("click", this.outsideClick);
    }

    disconnect() {
        document.removeEventListener("click", this.outsideClick);
    }

    preview() {
        const file = this.inputTarget.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = (e) => {
                this.imageTarget.src = e.target.result;
                this.showElement(this.checkTarget, this.trashTarget);
                this.hideElement(this.editTarget);
            };
            reader.readAsDataURL(file);
        }
    }

    toggleEdit() {
        this.showElement(this.checkTarget, this.trashTarget, this.labelTarget);
        this.hideElement(this.editTarget);
        this.isEditMode = true;
    }

    selectImage() {
        if (this.isEditMode) {
            this.inputTarget.click();
        }
    }

    outsideClick = (event) => {
        if (!this.element.contains(event.target) && this.isEditMode) {
            this.cancelEdit();
        }
    }

    cancelEdit() {
        this.hideElement(this.checkTarget, this.trashTarget, this.labelTarget);
        this.showElement(this.editTarget);
        this.isEditMode = false;
    }

    // Helper methods to manage element visibility
    hideElement(...elements) {
        elements.forEach(element => element.classList.add("hidden"));
    }

    showElement(...elements) {
        elements.forEach(element => element.classList.remove("hidden"));
    }
}
