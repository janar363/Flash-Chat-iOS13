
import UIKit
import AVKit
//import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let defaults = UserDefaults.standard
//
//        if defaults.bool(forKey: "didLogin") {
//            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "main", bundle: nil)
//            let chatViewController = mainStoryBoard.instantiateViewController(withIdentifier: "chatController") as! ChatViewController
//            DispatchQueue.main.async {
//                self.navigationController?.pushViewController(chatViewController, animated: true)
//            }
//        }
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("granted")
            } else {
                print("not granted")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        titleLabel.text = "⚡️FlashChat"
        
       
    }
    

}
