//
//  LoadingView.swift
//  ChatApp
//
//  Created by Liyana on 24/07/25.
//

import UIKit

class LoadingView: UIView {
    
    
    @IBOutlet var containerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)),bundle: nil)
        nib.instantiate(withOwner: self)
        containerView.frame = bounds
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(containerView)
     
        
    }
}
