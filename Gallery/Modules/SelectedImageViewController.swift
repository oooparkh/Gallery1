import UIKit

class SelectedImageViewController: UIViewController {

    @IBOutlet weak private var imageView: UIImageView!
    var selectedImage = UIImage()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = selectedImage
    }
}
