//
//  OwnerAlertViewController.swift
//  TermProject_05_19
//
//  Created by SJH on 2022/05/27.
//

import UIKit

class OwnerAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.performSegue(withIdentifier: "ChattingView", sender: self)
        
    }
    //백 버튼 숨기기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        Owner.loadOwner(sender: self)
        
    }
}

extension OwnerAlertViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChattingView"{
            print("ok")
        }
    }
}
