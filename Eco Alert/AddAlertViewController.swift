//
//  AddAlertViewController.swift
//  Eco Alert
//
//  Created by Yi Yang  Tan  on 5/8/17.
//  Copyright © 2017 Yi Yang  Tan . All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire

class AddAlertViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var myImageView: UIImageView!
    var chosenImage : UIImage?
    
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }
    
    
    
    
    //Save a new alert at current location
    @IBAction func saveButton(_ sender: Any) {
        let nameString:String = nameTextField.text!
        let descriptionString:String = descriptionTextField.text!
        
        let newMapPin:MapPin = MapPin(title: nameString, subtitle: descriptionString, coordinate: UserLocationController.deviceLocation())
        
        
        //post the alert onto our JSON server
        let newAlert:[String: Any] = ["name": nameString, "description": descriptionString, "latitude": String(newMapPin.coordinate.latitude),"longitude":String(newMapPin.coordinate.latitude)]
        
        Alamofire.request("https://jsonplaceholder.typicode.com/todos",method: .post,parameters: newAlert,encoding: JSONEncoding.default).validate().responseJSON{
            response in
            debugPrint(response)

        }
        
        
        
        
        //Ask LocationsController to add this new location and new pin and save it in CoreData
        LocationsController.addLocation(building: newMapPin)
        
        DatabaseController.saveContext()
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func selectPhotoTouched(_ sender: Any) {
        photoFromLibrary()
    }
    
    
    @IBAction func uploadImageTouched(_ sender: Any) {
        uploadPhoto(chosenImage!, params: ["name":"myImage"])
    }
    
    func photoFromLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            myImageView.contentMode = .scaleAspectFit
//            myImageView.image = chosenImage
//        }
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        myImageView.contentMode = .scaleAspectFit //3
        myImageView.image = chosenImage! //4
        dismiss(animated:true, completion: nil) //5
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK - Uplader Logic
    
    func uploadPhoto(_ photo: UIImage, params: [String: String]){
        var r  = URLRequest(url: URL(string: "http://messages.api.swiftengine.net/uploader.ssp")!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        r.httpBody = createBody(parameters: params,
                                boundary: boundary,
                                data: UIImageJPEGRepresentation(photo, 0.7)!,
                                mimeType: "image/jpg",
                                filename: "hello.jpg")
        
        let task = URLSession.shared.dataTask(with: r) {
            (responseData, urlResponse, error) in
            
            print("Done with upload: \(String(describing: urlResponse))")
            let alertController = UIAlertController(
                title: "Done",
                message: "Uploaded!",
                preferredStyle: UIAlertControllerStyle.alert
            )
            let confirmAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) { (action) in
                // ...
            }
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        task.resume()
        
        
    }
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    

    
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        self.append(data!)
    }

    
    
    
}
