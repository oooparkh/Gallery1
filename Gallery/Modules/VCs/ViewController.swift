import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var makePhotoButton: UIButton!
    @IBOutlet weak private var galleryButton: UIButton!
    @IBOutlet weak private var saveButton: UIButton!
    private let pickerController = UIImagePickerController()
     enum ImageSource {
        case photoLibrary
        case camera
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRadius()
        pickerController.allowsEditing = true
        pickerController.delegate = self
    }
    // MARK: - Setup
    private func makeRadius() {
        makePhotoButton.layer.cornerRadius = 25
        galleryButton.layer.cornerRadius = 25
        saveButton.layer.cornerRadius = 25
    }
    private func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    // MARK: - Actions
    @IBAction private func saveButtonPressed(_ sender: Any) {
        guard let selectedImage = imageView.image else {
            showAlertWith(title: "Error", message: "Choose photo to save")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self,
                                       #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil )
    }
    @IBAction private func makePhotoButtonPressed(_ sender: Any) {
             guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    @IBAction private func showGalleryButtonPressed(_ sender: Any) {
       selectImageFrom(.photoLibrary)
    }
    // MARK: - Logic
    @objc private func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?,
                                 contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    private func selectImageFrom(_ source: ImageSource) {
        switch source {
        case .camera:
            pickerController.sourceType = .camera
        case .photoLibrary:
            pickerController.sourceType = .photoLibrary
        }
        present(pickerController, animated: true, completion: nil)
    }
}

    // MARK: - Extentions

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     func imagePickerController(_ picker: UIImagePickerController,
                                didFinishPickingMediaWithInfo info: [ UIImagePickerController.InfoKey: Any ]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        imageView.image = selectedImage
        pickerController.dismiss(animated: true)
    }
}
