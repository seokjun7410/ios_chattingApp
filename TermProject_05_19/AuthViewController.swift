
import UIKit
import Firebase
import FirebaseAuth
import Progress

class AuthViewController: UIViewController{
        
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    @IBOutlet weak var passwdLabel2: UILabel!
    @IBOutlet weak var passwdLabel: UILabel!
    @IBOutlet weak var okaybutton: UIButton!
    
    var keyboardBool: Bool = false
    var WithoutKeyboard: NSLayoutConstraint?
    var WithKeyboard: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        passwdLabel2.text=""
        // NotificationCenter에 옵저버 등록을 한다.
        // 키보드가 나타나면 keyboardWillShow 함수를 호출한다
//        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil )
//        // 키보드가 사라지면 keyboardWillHide 함수를 호출한다
//        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil )
    }
    
    @IBAction func login(_ sender: UIButton) {
       okaybutton.layer.isHidden = true // 버튼 비활성화
        Prog.start(in: self, .activityIndicator)
        if let id = idTextField.text{//let passwd = passwdTextField.text
            let email = id + "@hansung.ac.kr"
            Auth.auth().signIn(withEmail: email, password: "123456") { Result, Error in
                if let _ = Error{
                    print("Login failure")
                    self.passwdLabel.text="다시 입력해 주세요"
                    self.passwdLabel2.text="비밀번호를가 틀렸습니다"
                    self.okaybutton.layer.isHidden = false // 버튼 활성화
                }else{
                    let ref = Firestore.firestore().collection("Owner")
                    let data = ["id": self.idTextField.text!] as [String : Any]
                    ref.document("id").setData(data)
                    self.performSegue(withIdentifier: "chattingVIew", sender: self)
                }
            }
        }
        Prog.dismiss(in: self)
       
    }

    @IBAction func register(_ sender: Any) {
        if let id = idTextField.text, let passwd = passwdTextField.text{
            let email = id + "@hansung.ac.kr"
            Auth.auth().createUser(withEmail: email, password: passwd) { Result, Error in
                if let _ = Error{
                    print("Register Failed")
                }else{
                    print("Register Success")
                }
            }
        }
    }
}

extension AuthViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chattingVIew"{
            okaybutton.layer.isHidden = false
            view.endEditing(true)
        }
    }
}

extension AuthViewController{
    @objc private func keyboardWillShow(_ notification: Notification) {
        if UIApplication.shared.statusBarOrientation.isLandscape {return}
        if keyboardBool == true{return}
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                       let keyboardRectangle = keyboardFrame.cgRectValue
                       let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                            self.view.window?.frame.origin.y -= keyboardHeight
                        }
               }
        keyboardBool = true
}
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        keyboardBool = false
        if UIApplication.shared.statusBarOrientation.isLandscape {return}
        if self.view.window?.frame.origin.y != 0 {
                    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                            let keyboardRectangle = keyboardFrame.cgRectValue
                            let keyboardHeight = keyboardRectangle.height
                        UIView.animate(withDuration: 1) {
                            self.view.window?.frame.origin.y += keyboardHeight
                        }
                    }
                }
        
    }
}
