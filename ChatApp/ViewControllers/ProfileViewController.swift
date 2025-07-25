//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Liyana on 25/07/25.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

   
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func logout() {
        do {
            try Auth.auth().signOut()
            let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let signinVC = authStoryboard.instantiateViewController(withIdentifier: "SignInViewController")
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = signinVC

        } catch {
            presentErrorAlert(title: "Logout Failed", message: "something went wrong with logout.Please try again later")
            
        }
    }
    

    @IBAction func logoutButtonTapped(_ sender: Any) {
            let logoutAlert = UIAlertController(title: "Confirms Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                let logoutAction = UIAlertAction(title: "Logout", style: .destructive){
                    _ in
                    self.logout()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                logoutAlert.addAction(logoutAction)
                logoutAlert.addAction(cancelAction)
                present(logoutAlert, animated: true)
               
    }
    

}
