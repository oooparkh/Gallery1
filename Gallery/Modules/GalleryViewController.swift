import Photos
import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    private var imageArray = [UIImage]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotosFromAlbum()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Logic
   private func getPhotosFromAlbum() {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            for item in 0..<fetchResult.count {
                imageManager.requestImage(for: fetchResult.object(at: item),
                                          targetSize: CGSize(width: 200, height: 200), contentMode: .default,
                                          options: requestOptions, resultHandler: { image, _ in
                    self.imageArray.append(image!)
                })
            }
        } else {
         DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
}
// MARK: - Extentions

// MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell",
                                                            for: indexPath) as?  PhotoCollectionViewCell else {
         return UICollectionViewCell()
        }
         cell.imageView.image = imageArray[indexPath.item]
         return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let selectedImageViewController = storyboard.instantiateViewController(identifier:
               String(describing: SelectedImageViewController.self)) as SelectedImageViewController
           selectedImageViewController.modalPresentationStyle = .fullScreen
           selectedImageViewController.selectedImage = imageArray[indexPath.item]
           self.navigationController?.pushViewController(selectedImageViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

}
