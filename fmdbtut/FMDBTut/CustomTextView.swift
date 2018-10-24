//
//  CustomTextView.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 31/10/2017.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation
import UIKit

class CustomTextView: UITextView {

    fileprivate lazy var transparentCoveringView = UIView()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) ||
            action == #selector(paste(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:)) ||
            action == #selector(cut(_:)) ||
            action == Selector(("_define:")) ||
            action == Selector(("_share:"))
        {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
    
    
    /**
     Override `becomeFirstResponder()`and return false to disable double-tap selection of links.
     */
    override public func becomeFirstResponder() -> Bool {
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSelectable = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSelectable = false
    }
}
