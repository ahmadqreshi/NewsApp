//
//  AddNewsViewController.swift
//  Assessment_3
//
//  Created by Admin on 22/03/22.
//

import UIKit
class AddNewsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak private var addImageView: UIImageView!
    @IBOutlet weak private var addTitle: UITextField!
    @IBOutlet weak private var shortDescription: UITextView!
    @IBOutlet weak private var fullDescription: UITextView!
    @IBOutlet weak private var date: UITextField!
    @IBOutlet weak private var titleCharacterLimit: UILabel!
    
    // MARK: - life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        date.delegate = self
        addTitle.delegate = self
        shortDescription.delegate = self
        fullDescription.delegate = self
        
        shortDescription.text = StringConstant.shortDescriptionPlaceholder.rawValue
        shortDescription.textColor = UIColor.lightGray
        
        fullDescription.text = StringConstant.fullDescriptionPlaceholder.rawValue
        fullDescription.textColor = UIColor.lightGray
        
        self.navigationItem.title = StringConstant.addNewsTitle.rawValue
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:)))
        tapGuesture.numberOfTapsRequired = 1
        addImageView.addGestureRecognizer(tapGuesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        titleCharacterLimit.connect(with: addTitle)
    }
    
    // MARK: - Delegates Method
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch textView{
            case shortDescription:
                textView.text = StringConstant.shortDescriptionPlaceholder.rawValue
                textView.textColor = UIColor.lightGray
            default:
                textView.text = StringConstant.fullDescriptionPlaceholder.rawValue
                textView.textColor = UIColor.lightGray
            }
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField{
        case date:
            if range.length == 0{
                return false
            }
            return true
        default:
            if range.length >= Constants.titleCharLimit && string.isEmpty && range.location == 0{
                return false
            }
            let newText = (addTitle.text! as NSString).replacingCharacters(in: range, with: string)
            let noSpaceText = (addTitle.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            if newText.count > Constants.titleCharLimit {
                addTitle.text = String(newText.prefix(Constants.titleCharLimit))
            }
            return newText.count <= Constants.titleCharLimit && noSpaceText.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //300 chars restriction
        switch textView{
        case shortDescription:
            var wordsArray = (shortDescription.text as NSString).components(separatedBy: " ")
            if wordsArray.count > Constants.shortDescWordsLimit && text.isEmpty{
                return false
            }
            let newText = (shortDescription.text as NSString).replacingCharacters(in: range, with: text)
            wordsArray = newText.components(separatedBy: " ")
           let noSpaceText = (shortDescription.text! as NSString).replacingCharacters(in: range, with: text) as NSString
            if newText.components(separatedBy: " ").count > Constants.shortDescWordsLimit {
                shortDescription.text = String(wordsArray.prefix(Constants.shortDescWordsLimit).joined(separator: " "))
            }
            return wordsArray.count <= Constants.shortDescWordsLimit && noSpaceText.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
        default:
            let noSpaceText = (fullDescription.text! as NSString).replacingCharacters(in: range, with: text) as NSString
            return true && noSpaceText.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        addImageView.image = image
        
    }
    
    // MARK: - Custom Methods
    @objc private func imageViewTapped(_ imageView: UIImage){
        if addImageView.image != UIImage(systemName: "nosign"){
            let alert = UIAlertController(title: StringConstant.confirm.rawValue, message: StringConstant.confirmMsg.rawValue, preferredStyle: UIAlertController.Style.actionSheet)
            let okayButton = UIAlertAction(title: StringConstant.photoLib.rawValue, style: UIAlertAction.Style.default) { action in
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
            let removeButton = UIAlertAction(title: StringConstant.removePhoto.rawValue, style: UIAlertAction.Style.default) { action in
                let picker = UIImagePickerController()
                picker.dismiss(animated: true, completion: nil)
                self.addImageView.image = UIImage(systemName: "nosign")
            }
            
            let cancelButton = UIAlertAction(title: StringConstant.cancel.rawValue, style: UIAlertAction.Style.cancel) { action in
            }
            alert.addAction(okayButton)
            alert.addAction(removeButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: StringConstant.addAlertTitle.rawValue, message: StringConstant.addAlertMsg.rawValue, preferredStyle: UIAlertController.Style.actionSheet)
        let okayButton = UIAlertAction(title: StringConstant.photoLib.rawValue, style: UIAlertAction.Style.default) { action in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: StringConstant.cancel.rawValue, style: UIAlertAction.Style.cancel) { action in
        }
        alert.addAction(okayButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction private func addBtnPressed(_ sender: UIButton) {
        
        guard let image = addImageView.image, !image.isEqual(UIImage(systemName: "nosign")) else {
            displayMyAlertMessage (StringConstant.displayImageAlert.rawValue)
            return
        }
        
        guard let title = addTitle.text, !title.isEmpty else {
            displayMyAlertMessage (StringConstant.displayTitleAlert.rawValue)
            return
        }
        
        guard let shortDesc = shortDescription.text, !shortDesc.isEmpty else {
            displayMyAlertMessage (StringConstant.displayShortdescAlert.rawValue)
            return
        }
        
        guard let shortDesc = shortDescription.text, shortDesc.components(separatedBy: " ").count >= Constants.shortDescMinimumWords else {
            displayMyAlertMessage (StringConstant.shortMinimumWordMsg.rawValue)
            return
        }
        
        guard let longDesc = fullDescription.text, !longDesc.isEmpty else {
            displayMyAlertMessage (StringConstant.displayFulldescAlert.rawValue)
            return
        }
        guard let longDesc = fullDescription.text, longDesc.components(separatedBy: " ").count >= Constants.fullDescMinimumWords else {
            displayMyAlertMessage (StringConstant.displayMinimumWords.rawValue)
            return
        }
        
        guard let date = date.text, !date.isEmpty else {
            displayMyAlertMessage (StringConstant.displayDateAlert.rawValue)
            return
        }
        
        DataModel.shared.addNews(NewsFields(image: image, title: title, shortDescription: shortDesc, fullDescription: longDesc, date: date, isFav: false))
        let myAlert = UIAlertController(title: StringConstant.submitted.rawValue, message: StringConstant.newsAddedSucccesful.rawValue , preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: StringConstant.ok.rawValue, style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        addImageView.image = UIImage(systemName: "nosign")
        addTitle.text = nil
        shortDescription.text = StringConstant.shortDescriptionPlaceholder.rawValue
        shortDescription.textColor = UIColor.lightGray
        fullDescription.text = StringConstant.fullDescriptionPlaceholder.rawValue
        fullDescription.textColor = UIColor.lightGray
        self.date.text = nil
        titleCharacterLimit.text = StringConstant.titleCharacterLimit.rawValue
    }
    
    private func displayMyAlertMessage(_ userMessage:String){
        let myAlert = UIAlertController(title: StringConstant.warning.rawValue, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: StringConstant.ok.rawValue, style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}


// MARK: - Extensions
extension AddNewsViewController{
    
    private func createpicker()
    {
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .dateAndTime
        date.inputView = datepicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let cancel = UIBarButtonItem(title: StringConstant.cancel.rawValue, style: .plain, target: self, action: #selector(self.cancelclick))
        let done = UIBarButtonItem(title: StringConstant.done.rawValue, style: .done, target: self, action: #selector(doneclick))
        let flexible  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancel , flexible ,done], animated: false)
        date.inputAccessoryView = toolbar
        datepicker.preferredDatePickerStyle  = .wheels
        datepicker.maximumDate = Date()
    }
    
    @objc private func cancelclick()
    {
        date.resignFirstResponder()
    }
    @objc private func doneclick()
    {
        if let datepicker = date.inputView as? UIDatePicker{
            let dateformat = DateFormatter()
            dateformat.dateStyle = .short
            dateformat.dateFormat = "dd/MM/yyyy"
            self.date.text = dateformat.string(from: datepicker.date)
        }
        date.resignFirstResponder()
    }
    
    
}
extension AddNewsViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textView: UITextField) {
        self.createpicker()
    }
}

extension UILabel {
    @objc
    func input(textField: UITextField) {
        if let length = textField.text?.count{
            self.text = "Character Limit : \(Constants.titleCharLimit - length)"
        }
    }
    func connect(with textField:UITextField){
        textField.addTarget(self, action: #selector(UILabel.input(textField:)), for: .editingChanged)
    }
}

