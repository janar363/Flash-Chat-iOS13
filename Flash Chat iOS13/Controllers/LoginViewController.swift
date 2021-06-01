
import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("login successful")
//                    let defaults = UserDefaults.standard
//                    defaults.setValue(true, forKey: "didLogin")
                    self.performSegue(withIdentifier: K .loginSegue, sender: self)
                    self.emailTextfield.text = ""
                    self.passwordTextfield.text = ""
                }
            }
        }
    }
    
}
