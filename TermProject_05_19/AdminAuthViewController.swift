//
//  AdminAuthViewController.swift
//  TermProject_05_19
//
//  Created by SJH on 2022/05/28.
//

import UIKit
import Progress
import FirebaseAuth
import Firebase
class AdminAuthViewController: UIViewController {

    @IBOutlet weak var passwdTextField: UITextField!

    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    
    var messageGroup: MessageGroup!
    var messageTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwd2Label.text=""
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser?.email != "123456@hansung.ac.kr"{
            performSegue(withIdentifier: "admin", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var passwd2Label: UILabel!
    @IBAction func loginButton(_ sender: Any) {
        try? Auth.auth().signOut()
        okayButton.layer.isHidden = true // 버튼 비활성화
         Prog.start(in: self, .activityIndicator)
         if let id = idTextField.text, let passwd = passwdTextField.text{//
             let email = id + "@hansung.ac.kr"
             Auth.auth().signIn(withEmail: email, password: passwd) { Result, Error in
                 if let _ = Error{
                     print("Login failure")
                     self.passwd2Label.text = "아이디 혹은 비밀번호가 틀렸습니다"
                     self.okayButton.layer.isHidden = false // 버튼 활성화
                 }else{
                     self.performSegue(withIdentifier: "admin", sender: self)
                     
                 }
             }
         }
         Prog.dismiss(in: self)

    }
}

extension AdminAuthViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "admin"{
            let svc = segue.destination as! AdminViewController
            svc.messageGroup = self.messageGroup
            svc.messagTable = self.messageTable
        }
    }
}
