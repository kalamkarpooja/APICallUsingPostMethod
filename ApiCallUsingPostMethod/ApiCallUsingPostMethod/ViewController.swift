//
//  ViewController.swift
//  ApiCallUsingPostMethod
//
//  Created by Mac on 16/06/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bodyField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var idFoield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func postBtn(_ sender: Any) {
       setUpMethod()
    
   }
}
extension ViewController{
    func setUpMethod(){
        guard let uid = self.idFoield.text else{return}
        guard let title = self.titleField.text else {return}
        guard let body = self.bodyField.text else{return}
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameters : [String : Any] = [
                "userId" : uid,
                "title" : title,
                "body" : body
            ]
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
            URLSession.shared.dataTask(with: request){(data,response,error) in
                guard let data = data else {
                    if error == nil{
                        print(error?.localizedDescription ?? "unknown error")
                    }
                    return
                }
                if let response = response  as? HTTPURLResponse{
                    guard (200 ... 299) ~= response.statusCode else{
                        print("status code: -\(response.statusCode)")
                        print(response)
                    return
                }
            }
                do{
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(data)
                }catch let error{
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
  }
}
extension Dictionary{
    func percentEscaped() -> String{
        return map{(key,Value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValues = "\(Value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValues
            
        }
        .joined(separator: "&")
    }
}
extension CharacterSet{
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDeliMeterToEncode = ":#[]@"
        let subDelimeterToEncode = "!$&'()*+;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDeliMeterToEncode)\(subDelimeterToEncode)")
        return allowed
    }()
}
