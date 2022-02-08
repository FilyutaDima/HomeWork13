//
//  ViewController.swift
//  HomeWork13
//
//  Created by Dmitry on 6.02.22.
//

import UIKit

protocol ColorEditorDelegate: AnyObject {
    func changeBackgroundColor(with color: UIColor)
}

class ViewController: UIViewController, ColorEditorDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction private final func tappedChangeBgButton() {
        performSegue(withIdentifier: Constants.goToColorEditorVC, sender: self)
    }
    
    func changeBackgroundColor(with color: UIColor) {
        view.backgroundColor = color
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ColorEditorVC else { return }
        destination.originalColor = view.backgroundColor
        destination.delegate = self
    }
}

