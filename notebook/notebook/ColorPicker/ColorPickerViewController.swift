//
//  ColorPickerViewController.swift
//  notebook
//
//  Created by Павел Кошара on 25/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorPickerState: NSObject {
    public var selectedColorLocation: CGPoint? = nil
    public var selectedColor: UIColor
    public var brightness: Float
    
    public init(color: UIColor, brightness: Float = 1) {
        self.selectedColor = color
        self.brightness = brightness
    }
}

class ColorPickerViewController: UIViewController {
    @IBOutlet private weak var colorPickerView: ColorPickerView! {
        didSet {
            if let state = state {
                colorPickerView.state = state
            }
        }
    }
    
    public weak var delegate: ColorPickerViewControllerDelegate?
    public var state: ColorPickerState? = nil
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.didDismiss?(state: colorPickerView.state)
    }
}

@objc protocol ColorPickerViewControllerDelegate {
    @objc optional func didDismiss(state: ColorPickerState)
}
