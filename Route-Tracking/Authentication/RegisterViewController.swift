//
//  RegisterViewController.swift
//  Route-Tracking
//
//  Created by Kudo on 9/13/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("Error creating user")
            } else {
                let db = Firestore.firestore()
                db.collection(K.View.mainView).addDocument(data : ["name" : name, "uid": result!.user.uid ]) { (error) in
                    if error != nil {
                        print("Error storing userdata")
                    } else {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier : K.View.mainView) as? ViewController
                        self.view.window?.rootViewController = nextVC
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
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

}
