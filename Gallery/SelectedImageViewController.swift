//
//  SelectedImageViewController.swift
//  Gallery
//
//  Created by Alexey on 23.02.21.
//

import UIKit

class SelectedImageViewController: UIViewController {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var selectedImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        selectedImageView.image = selectedImage
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let imagePath = UserDefaults.standard.value(forKey: "imagePathKey") as? String {
            
            let deleteAlert = UIAlertController(title: "Delete photo", message: "Are you sure?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.navigationController?.popViewController(animated: true)
                if FileManager.default.fileExists(atPath: imagePath) {
                    do {
                        try FileManager.default.removeItem(atPath: imagePath)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            present(deleteAlert, animated: true, completion: nil)
        }
    
    }
    
   
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let imagePath = UserDefaults.standard.value(forKey: "imagePathKey") as? String {
            if let image = UIImage(contentsOfFile: imagePath) {
                let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                present(shareController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
    }
}
