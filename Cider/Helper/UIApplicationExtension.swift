//
//  UIApplicationExtension.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/29.
//

import SwiftUI

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else {
            return
        }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        rightSwipeGesture.direction = .right
        rightSwipeGesture.delegate = self
        window.addGestureRecognizer(rightSwipeGesture)
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        leftSwipeGesture.direction = .left
        leftSwipeGesture.delegate = self
        window.addGestureRecognizer(leftSwipeGesture)
        
        let upSwipeGesture = UISwipeGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        upSwipeGesture.direction = .up
        upSwipeGesture.delegate = self
        window.addGestureRecognizer(upSwipeGesture)
        
        let downSwipeGesture = UISwipeGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        downSwipeGesture.direction = .down
        downSwipeGesture.delegate = self
        window.addGestureRecognizer(downSwipeGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecongizesSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
