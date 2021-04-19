import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var makePhotoButton: UIButton!
    @IBOutlet weak private var galleryButton: UIButton!
    @IBOutlet weak private var saveButton: UIButton!
    private let pickerController = UIImagePickerController()
     enum ImageSource {
        case photoLibrary
        case camera
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRadius()
        pickerController.allowsEditing = true
        pickerController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    private func makeRadius() {
        makePhotoButton.layer.cornerRadius = cornerRadius
        galleryButton.layer.cornerRadius = cornerRadius
        saveButton.layer.cornerRadius = cornerRadius
    }
    
    // MARK: - Actions
    @IBAction private func tappedSave(_ sender: Any) {
        guard let selectedImage = imageView.image else {
            showAlertWith(title: "Error", message: "Choose photo to save")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self,
                                       #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil )
    }
    
    @IBAction private func tappedMakePhoto(_ sender: Any) {
             guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    @IBAction private func tappedShowGallery(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let galleryViewController = String(describing: GalleryViewController.self)
        let viewController = storyboard.instantiateViewController(identifier: galleryViewController)
            as GalleryViewController
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func saveImage(_ image: UIImage,
                                 didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    // MARK: - Logic
    private func selectImageFrom(_ source: ImageSource) {
        switch source {
        case .camera:
            pickerController.sourceType = .camera
        case .photoLibrary:
            pickerController.sourceType = .photoLibrary
        }
        present(pickerController, animated: true, completion: nil)
    }
    
    private func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

    // MARK: - Extentions
extension StartViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     func imagePickerController(_ picker: UIImagePickerController,
                                didFinishPickingMediaWithInfo info: [ UIImagePickerController.InfoKey: Any ]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        imageView.image = selectedImage
        pickerController.dismiss(animated: true)
    }
}
