//
//  Message.swift
//  Assignment
//
//  Created by Jitendra on 23/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import UIKit
import SwiftMessages

class Message {
    
    static func showErrorMessage(text: String, second: TimeInterval = 3) {
        
        let errorView = (try? SwiftMessages.viewFromNib()) ?? MessageView()
        errorView.configureTheme(backgroundColor: UIColor.red, foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), iconImage: nil, iconText: nil)
        errorView.bodyLabel?.font = UIFont.systemFont(ofSize: 15)
        errorView.bodyLabel?.text = text
        
        errorView.button?.setImage(Icon.ErrorSubtle.image, for: .normal)
        errorView.button?.setTitle(nil, for: .normal)
        errorView.button?.backgroundColor = UIColor.clear
        errorView.button?.tintColor = UIColor.white
        errorView.button?.addTarget(self, action: #selector(hideMessage), for: .touchUpInside)
        
        errorView.iconImageView?.isHidden = true
        errorView.titleLabel?.isHidden = true
        
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        statusConfig.duration = .seconds(seconds: second)
        statusConfig.presentationStyle = .top
        
        SwiftMessages.show(config: statusConfig, view: errorView)
    }
    
    @objc static func hideMessage() {
        SwiftMessages.hide()
    }
}
