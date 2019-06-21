//
//  LoginViewController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/16/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TransitionButton

class APIvariables {
    private init() {}
    static let shared = APIvariables()

    var URLApi = "https://frozen-citadel-27418.herokuapp.com/"
    var idUser = ""
    var token = ""
    var userUsage = ""
    var appName = ""
    var appImagePath = ""
    var profileType = 0
}

class LoginViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var buttonActive : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func login(url: String, parameters: [String:String], completion: @escaping(Any?)-> Void) {
        Alamofire.request(url, method: .post, parameters: parameters).validate().responseJSON(completionHandler: { response in
            guard let value = response.result.value else {
                completion(nil)
                return
            }
            if response.result.isSuccess {
                print("Success post")
                
                let userJSON: JSON = JSON(value)
                APIvariables.shared.token = userJSON["token"].stringValue
                APIvariables.shared.idUser = userJSON["id"].stringValue
                APIvariables.shared.appName = userJSON["firstName"].stringValue
                APIvariables.shared.appImagePath = userJSON["userImage"].stringValue
                APIvariables.shared.profileType = userJSON["profileType"].intValue
                let checkCompletion = userJSON["profileType"].intValue
                self.buttonActive = true
                completion(checkCompletion)
            }
            else{

                print("WTF")
                
                self.buttonActive = false
                completion(self.buttonActive)
            }
            
        })
    }
    
    @IBAction func loginAction(_ button: TransitionButton) {
        button.startAnimation()
        let route = APIvariables.shared.URLApi + "login"
        let body = ["email": "\(emailTextField.text!)", "password": "\(passwordTextField.text!)"]
        print(body)
    
        self.login(url: route, parameters: body){_ in
            if self.buttonActive == true{
                print("Ready to go" + APIvariables.shared.token + APIvariables.shared.appImagePath)
                button.stopAnimation(animationStyle: .expand, completion: {
                    if APIvariables.shared.profileType == 0 {
                        self.performSegue(withIdentifier: "goToOptions", sender: nil)
                    }
                    else if APIvariables.shared.profileType == 1 {
                        self.performSegue(withIdentifier: "loginToKnowledge", sender: nil)
                    }
                    else if APIvariables.shared.profileType == 2 {
                        self.performSegue(withIdentifier: "loginToEntertainment", sender: nil)
                    }
                    else if APIvariables.shared.profileType == 3 {
                        self.performSegue(withIdentifier: "loginToHealth", sender: nil)
                    }
                    else if APIvariables.shared.profileType == 4 {
                        self.performSegue(withIdentifier: "loginToSocial", sender: nil)
                    }
                })
            }
            else{
                print("Not ready something happened" + APIvariables.shared.appName)
                button.stopAnimation(animationStyle: .shake, completion: nil)
            }
        }
    }
}
