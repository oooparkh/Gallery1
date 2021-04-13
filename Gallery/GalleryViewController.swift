//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Alexey on 23.02.21.
//

import UIKit


class GalleryViewController: UIViewController {

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let pickerController = UIImagePickerController()
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default
    lazy var imagesPath = documentsPath.appendingPathComponent("Images")
    var imagesArray = [UIImage]()
    var arrayOfNamed = [String]()
    var previousSelected: IndexPath?
    var currentSelected: Int?
    var numberOfImage = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        addPhotoButton.layer.cornerRadius = 25
        pickerController.allowsEditing = true
        pickerController.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        createDirectory()
        createImages()
        collectionView.reloadData()
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Photo", message: "From camera or gallery?", preferredStyle: .alert)
        let libraryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            self.pickPhoto()
        }
        let cameraActiom = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.pickCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(libraryAction)
        alert.addAction(cameraActiom)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func createDirectory() {
        if let login = UserDefaults.standard.value(forKey: UserDefault.login.rawValue) as? String {
            let newPath = imagesPath.appendingPathComponent(login)
            try? fileManager.createDirectory(at: newPath, withIntermediateDirectories: true, attributes: nil)
            print(newPath)
            print("user \(login)")
        } else {
            print ("error")
        }
    }
    
    func createImages() {
        imagesArray.removeAll()
        if let login = UserDefaults.standard.value(forKey: "Login") as? String {
            if let imageNames = try? fileManager.contentsOfDirectory(atPath: "\(imagesPath.path)/\(login)") {
                for imageName in imageNames {
                    if let image = UIImage(contentsOfFile: "\(imagesPath.path)/\(login)/\(imageName)") {
                        imagesArray.append(image)
                        arrayOfNamed.append(imageName)
                    }
                }
            }
        }
    }
    
    func pickCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        } else {
            let errorAlert = UIAlertController(title: "Error", message: "This device does not support camera", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func pickPhoto() {
        self.pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
}


extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info [.editedImage] as? UIImage {
            if fileManager.fileExists(atPath: imagesPath.path) == false {
                do {
        try fileManager.createDirectory(atPath: imagesPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("error 2")
                }
            }
            imagesArray.append(image)
            let data = image.jpegData(compressionQuality: 1)
            let imageName = "\(Date().timeIntervalSince1970).png"
            arrayOfNamed.append(imageName)
            
            if UserDefaults.standard.value(forKey: "Login") as? String != nil {
                let userLogin = UserDefaults.standard.value(forKey: "Login")
                let folderPath = "\(imagesPath.path)/\(userLogin ?? "")"
                if fileManager.createFile(atPath: "\(folderPath)/\(imageName)", contents: data, attributes: nil) {
                } else {
                    print ("error 3")
                }
            }
        }
        pickerController.dismiss(animated: true)
        collectionView.reloadData()
    }
}

extension GalleryViewController: UICollectionViewDataSource,
          UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell =
       collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as?
            ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = imagesArray[indexPath.item]
        numberOfImage = indexPath.item
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedImageViewController = storyboard.instantiateViewController(identifier:
            String(describing: SelectedImageViewController.self)) as SelectedImageViewController
        selectedImageViewController.modalPresentationStyle = .fullScreen
       
        UserDefaults.standard.setValue(arrayOfNamed, forKey: "arrayOfNamedKey")
        UserDefaults.standard.setValue(numberOfImage, forKey: "numberOfImageKey")
        
        if UserDefaults.standard.value(forKey: "Login") != nil {
            let userLogin = UserDefaults.standard.value(forKey: "Login")
            let imagePath = "\(documentsPath.absoluteURL.absoluteString)Images/\(userLogin ?? "")/\(arrayOfNamed[numberOfImage])".replacingOccurrences(of: "file://", with: "")
            UserDefaults.standard.setValue(imagePath, forKey: "imagePathKey")
        }
        selectedImageViewController.selectedImage = imagesArray[indexPath.item]
        self.navigationController?.pushViewController(selectedImageViewController, animated: true)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenWidth = self.view.frame.width
            let itemsPerRow: CGFloat = 2
            let paddingWidth = 20 * (itemsPerRow + 1)
            let availableWidth = screenWidth - paddingWidth
            let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)

        }
    
}
