//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Create an account here.",attributes: [.font: Font.caption])
        attributedString.addAttribute(.link, value: "chatappsignin://signAccount", range: (attributedString.string as NSString).range(of: "Create an account here."))
        createAccountTextView.attributedText = attributedString
        createAccountTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondary, .font: Font.linkLabel]
        createAccountTextView.delegate = self
        createAccountTextView.isScrollEnabled = false
        createAccountTextView.textAlignment = .center
        createAccountTextView.isEditable = false
        createAccountTextView.isSelectable = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(backgroundTap)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyBoardNotifications()
    }
 func registerKeyboardNotifications() {
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
   }

    func removeKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardOffset = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        let totalOffset = activeTextField == nil ? keyboardOffset : keyboardOffset + activeTextField!.frame.height
        scrollView.contentInset.bottom = totalOffset

        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        guard let password = passwordTextField.text else {
            presentErrorAlert(title: "password Required", message: "Please enter a password to continue")
            return
        }
        guard let email = emailTextField.text else {
            presentErrorAlert(title: "Email Required", message: "Please enter an email to continue")
            return
        }
        showLoadingView()
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.removeLoadingView()
            if let error = error {
                print(error.localizedDescription)
                
                var errorMessage = "Somthing went wrong. Please try again later"
                if let authError = AuthErrorCode(rawValue: error._code)
                {
                    switch authError {
                    case .userNotFound:
                        errorMessage = "email/password doesn't user records"
                    case .invalidEmail:
                        errorMessage = "invalid email"
                    default:
                        errorMessage = error.localizedDescription
                    }
                }
                self.presentErrorAlert(title: "Sign In Failed", message: errorMessage)
                return
            }
            print("Sign-in successful for user: \(result?.user.uid ?? "N/A")")
            guard let result = result else {
                       // This case is unlikely but good for defensive coding.
                       self.presentErrorAlert(title: "Sign In Success", message: "Successfully signed in, but no user data found.")
                       return
                   }
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            let navVC = UINavigationController(rootViewController: homeVC)
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = navVC
            
        }
        
    }

}
extension SignInViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "chatappsignin" {
            performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
        }
        return false
    }
    
}
extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextField = nil
    }
}
