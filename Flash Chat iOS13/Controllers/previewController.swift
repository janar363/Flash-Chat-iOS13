import UIKit
import AVKit

class previewController: UIViewController {

    public var imageData: Data?
    @IBOutlet weak var previewImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Delete", style: .plain, target: nil, action: nil)
        previewImage.image = UIImage(data: imageData!)
        previewImage.transform = previewImage.transform.rotated(by: CGFloat(Double.pi + Double.pi))
        
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = mainStoryboard.instantiateViewController(withIdentifier: "chatController") as! ChatViewController
        DispatchQueue.main.async {
            chatViewController.photoData = self.imageData
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
        
    }
}

