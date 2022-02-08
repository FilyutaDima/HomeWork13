//
//  BackgroundСolorEditorVC.swift
//  HomeWork13
//
//  Created by Dmitry on 7.02.22.
//

import UIKit

class ColorEditorVC: UIViewController {
    
    weak var delegate: ColorEditorDelegate?
    private var selectedColor: UIColor?
    var originalColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        initKeyboardObserver()
        initViews()
    }
    
    @IBOutlet private final weak var colorView: UIView!
    @IBOutlet private final weak var redSlider: UISlider!
    @IBOutlet private final weak var greenSlider: UISlider!
    @IBOutlet private final weak var blueSlider: UISlider!
    @IBOutlet private final weak var opacitySlider: UISlider!
    @IBOutlet private final weak var hexColorTextView: UITextField!
    @IBOutlet private final weak var redTextField: UITextField!
    @IBOutlet private final weak var greenTextField: UITextField!
    @IBOutlet private final weak var blueTextField: UITextField!
    @IBOutlet private final weak var opacityTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func redSliderChanged(_ sender: UISlider!) {
        changeColorView()
        
        let value = convertValue(value: sender.value, maxValue: 255.0)
        redTextField.text = value
    }
    @IBAction func greenSliderChanged(_ sender: UISlider!) {
        changeColorView()
        
        let value = convertValue(value: sender.value, maxValue: 255.0)
        greenTextField.text = value
    }
    @IBAction func blueSliderChanged(_ sender: UISlider!) {
        changeColorView()
        
        let value = convertValue(value: sender.value, maxValue: 255.0)
        blueTextField.text = value
    }
    @IBAction func tappedDoneButton(_ sender: Any) {
        guard let selectedColor = selectedColor else { return }
        delegate?.changeBackgroundColor(with: selectedColor)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func opacitySliderChanged(_ sender: UISlider!) {
        let value = convertValue(value: sender.value, maxValue: 100.0)
        opacityTextField.text = "\(value)%"
        changeColorView()
    }
    @IBAction func opacityEditingDidEnd(_ sender: UITextField) {
        guard let value = Int(sender.text ?? "") else { return }
        sender.text = "\(String(value))%"
    }
    @IBAction func opacityChanged(_ sender: UITextField) {
        guard let value = Float(sender.text ?? "") else { return }
        opacitySlider.value = value / 100
        changeColorView()
    }
    @IBAction func hexColorChanged(_ sender: UITextField) {
        guard Float(sender.text ?? "") != nil else { return }
        changeColorView()
    }
    @IBAction func blueColorChanged(_ sender: UITextField) {
        guard let value = Float(sender.text ?? "") else { return }
        changeColorView()
        blueSlider.value = value / 255
    }
    @IBAction func greenColorChanged(_ sender: UITextField) {
        guard let value = Float(sender.text ?? "") else { return }
        greenSlider.value = value / 255
        changeColorView()
    }
    @IBAction func redColorChanged(_ sender: UITextField) {
        guard let value = Float(sender.text ?? "") else { return }
        changeColorView()
        redSlider.value = value / 255
    }
    private func changeColorView() {
    
        selectedColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: CGFloat(opacitySlider.value))
        
        colorView.backgroundColor = selectedColor
        hexColorTextView.text = selectedColor!.hexString
    }
    
    private func initViews() {
        guard let originalColor = originalColor else { return }
        guard let components = originalColor.cgColor.components else { return }
        
        let redValue = getColorValue(components: components, index: 0)
        let greenValue = getColorValue(components: components, index: 1)
        let blueValue = getColorValue(components: components, index: 2)
        let opacityValue = getColorValue(components: components, index: 3)
        
        redSlider.value = redValue
        redTextField.text = convertValue(value: redValue, maxValue: 255)
        greenSlider.value = greenValue
        greenTextField.text = convertValue(value: greenValue, maxValue: 255)
        blueSlider.value = blueValue
        blueTextField.text = convertValue(value: blueValue, maxValue: 255)
        opacitySlider.value = opacityValue
        opacityTextField.text = "\(convertValue(value: opacityValue, maxValue: 100))%"
        
        hexColorTextView.text = originalColor.hexString
        colorView.backgroundColor = originalColor
    }
    
    private func getColorValue(components: [CGFloat], index: Int) -> Float {
        return components.count >= (index + 1) ? Float(components[index]) : 1.0
    }
    
    private func convertValue(value: Float, maxValue: Float) -> String {
        
        return String(Int(value * maxValue))
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func initKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ColorEditorVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ColorEditorVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
