//
//  ViewController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/6/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.performSegue(withIdentifier: "goToLogin", sender: self )
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

