//
//  UseSelectionViewController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/16/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import TransitionButton
import Alamofire
import SwiftyJSON

class UseSelectionViewController: CustomTransitionViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageArray = [UIImage]()
    
    @objc func imageTapped0(sender: UIImageView) {
        print("fuck you 0")
        let uri = APIvariables.shared.URLApi + "updateProfileType/" + APIvariables.shared.idUser
        let completeToken = "bearer " + APIvariables.shared.token
        let parameters = ["profileType":1]
        let headers = ["Authorization": completeToken]
        self.update(url: uri, parameters: parameters, headers: headers)
        performSegue(withIdentifier: "loadMainTab", sender: nil)
    }
    
    @objc func imageTapped1(sender: UIImageView) {
        print("fuck you 1")
        let uri = APIvariables.shared.URLApi + "updateProfileType/" + APIvariables.shared.idUser
        let completeToken = "bearer " + APIvariables.shared.token
        let parameters = ["profileType":2]
        let headers = ["Authorization": completeToken]
        self.update(url: uri, parameters: parameters, headers: headers)
    }
    
    @objc func imageTapped2(sender: UIImageView) {
        print("fuck you 2")
        let uri = APIvariables.shared.URLApi + "updateProfileType/" + APIvariables.shared.idUser
        let completeToken = "bearer " + APIvariables.shared.token
        let parameters = ["profileType":3]
        let headers = ["Authorization": completeToken]
        self.update(url: uri, parameters: parameters, headers: headers)
    }
    
    @objc func imageTapped3(sender: UIImageView) {
        print("fuck you 3")
        let uri = APIvariables.shared.URLApi + "updateProfileType/" + APIvariables.shared.idUser
        let completeToken = "bearer " + APIvariables.shared.token
        let parameters = ["profileType":4]
        let headers = ["Authorization": completeToken]
        self.update(url: uri, parameters: parameters, headers: headers)
    }
    
    @objc func imageTapped4(sender: UIImageView) {
        print("fuck you 4")
        let uri = APIvariables.shared.URLApi + "updateProfileType/" + APIvariables.shared.idUser
        let completeToken = "bearer " + APIvariables.shared.token
        let parameters = ["profileType":5]
        let headers = ["Authorization": completeToken]
        self.update(url: uri, parameters: parameters, headers: headers)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        imageArray = [#imageLiteral(resourceName: "Knowledge Card"), #imageLiteral(resourceName: "Social Card"), #imageLiteral(resourceName: "Health Card"), #imageLiteral(resourceName: "Entertainment Card"), #imageLiteral(resourceName: "Custom Card")]
        
        for i in 0..<imageArray.count{
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            //now you need a tap gesture recognizer
            //note that target and action point to what happens when the action is recognized.
            var tapRecognizer = UITapGestureRecognizer()
            switch i{
            case 0:
                tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped0))
            case 1:
                tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped1))
            case 2:
                tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped2))
            case 3:
                tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped3))
            case 4:
                tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped4))
            default:
                print("LOL")
            }

            //Add the recognizer to your view.
            imageView.addGestureRecognizer(tapRecognizer)
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let yPosition = 214 * CGFloat(i)
            imageView.frame = CGRect(x: 0, y: yPosition, width: 414, height: 214)
            
            scrollView!.contentSize.height = 1070
            scrollView!.addSubview(imageView)
        
        }

    }
    
    func update(url: String, parameters: [String:Int], headers: [String:String]) {
        Alamofire.request(url, method: .patch, parameters: parameters, headers: headers).validate().responseJSON { response in
            
            if response.result.isSuccess {
                print("Success patch")
            }
            else{
                print("WTF")
            }
            
        }
    }
    

}
