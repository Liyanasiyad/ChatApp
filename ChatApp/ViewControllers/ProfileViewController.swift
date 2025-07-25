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
        avatarImageView.image = UIImage(systemName: "person.fill")
        avatarImageView.tintColor = UIColor.black
        avatarImageView.backgroundColor = UIColor.lightGray
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(presentAvatarOptions))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(avatarTap)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 8
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
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
    @objc func presentAvatarOptions() {
        let avatarOptionSheet = UIAlertController(title: "Change avatar", message: "select an option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
        }
        let deleteAction = UIAlertAction(title: "Delete Avatar", style: .destructive) { _ in
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        avatarOptionSheet.addAction(cameraAction)
        avatarOptionSheet.addAction(photoAction)
        avatarOptionSheet.addAction(deleteAction)
        avatarOptionSheet.addAction(cancelAction)
        present(avatarOptionSheet, animated: true)
        
        
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
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
