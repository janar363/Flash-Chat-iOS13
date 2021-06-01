
import UIKit
import AVKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var photoData: Data?
    
    let db = Firestore.firestore()
    
    var messages: [AnyObject] = []
    
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "⚡️FlashChat"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        
        // registering our table view with the custom xib
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.register(UINib(nibName: K.imageNib, bundle: nil), forCellReuseIdentifier: K.imageCellIdentifier)
        
        // loading our msg from database
//        sendPressed(UIButton())
        if photoData != nil {
        print(photoData!)
        }
        loadMessages()
        sendPressed(sendButton)
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querrySnapshot, error) in
            if let e = error {
                print("Issue retreving data from firestore due to \(e.localizedDescription)")
            } else {
                self.messages = []
                if let snapshotDocs = querrySnapshot?.documents {
                    for doc in snapshotDocs {
                        let data = doc.data()
                        if data[K.FStore.dataType] as! String == "text" {
                            if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                self.messages.append(Message(sender: sender, body: messageBody, msgType: "text") as AnyObject)
                                
                            }
                        }
                        else {
                            if let sender = data[K.FStore.senderField] as? String, let imageData = data[K.FStore.imageField] as? Data {
                                self.messages.append(Image(sender: sender, imgData: imageData, msgType: "image") as AnyObject)

                            }
                        }
                        
                        
                    }
                    self.tableView.reloadData()
                    
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    if indexPath.row >= 0 {
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        // sending data to firestore database
        let messageBody = messageTextfield.text
        
        
        if let sender = Auth.auth().currentUser?.email {
            if  messageBody != ""{
                    db.collection(K.FStore.collectionName).addDocument(data: [
                        K.FStore.bodyField: messageBody,
                        K.FStore.senderField: sender,
                        K.FStore.dataType: "text",
                        K.FStore.dateField: Date().timeIntervalSince1970
                    ]) { (error) in
                        if let e = error {
                            print("Unable to save data due to \(e.localizedDescription)")
                        } else {
                            print("Data saved successfully")
                        }
                    }
    //            messages = []
    //            loadMessages()
            } else if photoData != nil {
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.imageField: photoData,
                    K.FStore.senderField: sender,
                    K.FStore.dataType: "image",
                    K.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error {
                        print("Unable to save data due to \(e.localizedDescription)")
                    } else {
                        print("Data saved successfully")
                    }
                }
            }
            messageTextfield.text = ""
            photoData = nil
            loadMessages()
        }
    }
    
    @IBAction func camButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.chatToCam, sender: self)
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = messages[indexPath.row] as? Image {
            photoData = cell.imgData
            performSegue(withIdentifier: K.chatToPreview, sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as? previewController
        target?.imageData = photoData
        
        target?.navigationItem.rightBarButtonItem = nil
        photoData = nil
    }
    
}

//MARK: - populating chatViewController

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row] as? Message
        
        if let actualMsg = message {
//            print("Enterd do")
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
            
            cell.label.text = actualMsg.body
            
            if actualMsg.sender == Auth.auth().currentUser?.email {
                cell.leftImageView.isHidden = true
                cell.rightImageView.isHidden = false
                cell.label.textAlignment = .right
                cell.label.textColor = .black
                cell.messageBubble.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.rightImageView.isHidden = true
                cell.leftImageView.isHidden = false
                cell.label.textAlignment = .left
                cell.label.textColor = .white
                cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.darkGray)
            }
            return cell
            
        } else {
            let image = messages[indexPath.row] as! Image
//            print("Entered Catch")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.imageCellIdentifier, for: indexPath) as! ImageViewCell
            
            cell.imageMsg.image = UIImage(data: image.imgData)
            
            
            
            if image.sender == Auth.auth().currentUser?.email {
                cell.leftImageView.isHidden = true
                cell.rightImageView.isHidden = false
                cell.imageBubble.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.rightImageView.isHidden = true
                cell.leftImageView.isHidden = false
                cell.imageBubble.backgroundColor = UIColor(named: K.BrandColors.darkGray)
            }
            return cell
        }
    }
    
    
}


