//
//  BooksViewController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/19/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke

class BooksCell: UITableViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
}

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var weatherIcon1: UIImageView!
    @IBOutlet weak var weatherIcon2: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var books = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentDate = Date()
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        
        dateFormatter1.dateFormat = "EEEE"
        dateFormatter2.dateFormat = "d MMMM YYYY"
        
        let dayInWeek = dateFormatter1.string(from: currentDate)
        let dateSpanish = dateFormatter2.string(from: currentDate)
        
        let imagePath = "\(APIvariables.shared.URLApi)\(APIvariables.shared.appImagePath)"
        let okWtf = imagePath.replacingOccurrences(of: "\\", with: "/")
        let imageURL = URL(string: okWtf)
        
        DispatchQueue.main.async {
            self.welcomeLabel.text = "Bienvenido: " + APIvariables.shared.appName
            self.weatherLabel.text = "Lima, " + WeatherVariables.shared.condition + ", " + WeatherVariables.shared.temperature + "º C"
            self.dayLabel.text = dayInWeek
            self.dateLabel.text = dateSpanish
            let pathForWeather = WeatherVariables.shared.icon.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let parsedOneWth = "https:" + pathForWeather!
            loadImage(with: URL(string: parsedOneWth)!, into: self.weatherIcon2)
            loadImage(with: URL(string: parsedOneWth)!, into: self.weatherIcon1)
            
            loadImage(with: imageURL!, into: self.profileImage)
            
            self.getBooks(url: "https://api.itbook.store/1.0/new", completion: {_ in
                self.tableView.reloadData()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                
                let whatToSpeak = "Available for reading according to your preferences. " + self.books[0]["title"].stringValue + ". " + self.books[0]["subtitle"].stringValue
                SpeechService.shared.speak(text: whatToSpeak, voiceType: .waveNetFemale) {
                    print("Reading news")
                }
            })
        }
    }
    
    func getBooks(url: String, completion: @escaping(Any?)-> Void){
        Alamofire.request(url, method: .get).validate().responseJSON {
            response in
            if response.result.isSuccess{
                print("Succes man")
                let newsJSON = JSON(response.result.value!)
                for i in 0..<newsJSON["books"].count{
                    let content = newsJSON["books"][i]
                    self.books.append(content)
                    print(content)
                }
                completion(self.books)
                print(self.books)
            }
            else{
                print("------------------not working asdasdasd sdasdasvdsvdasdsad")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booksCell", for: indexPath) as! BooksCell
        
 
        let okMan = self.books[indexPath.row]["image"].stringValue
        var meDammit = ""
        if okMan.isEmpty {
            meDammit = NewsVariables.shared.defaultNewBg.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        }
        else{
            meDammit = okMan.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        }
        
        let urlNewImage = URL(string: meDammit)
        
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.lineBreakMode = .byWordWrapping
        cell.titleLabel?.text = self.books[indexPath.row]["title"].stringValue
        cell.titleLabel.sizeToFit()
        
        cell.priceLabel.numberOfLines = 0
        cell.priceLabel.lineBreakMode = .byWordWrapping
        cell.priceLabel?.text = self.books[indexPath.row]["price"].stringValue
        
        cell.subtitleLabel.numberOfLines = 0
        cell.subtitleLabel.lineBreakMode = .byWordWrapping
        cell.subtitleLabel?.text = self.books[indexPath.row]["subtitle"].stringValue
        cell.subtitleLabel.sizeToFit()
        
        loadImage(with: urlNewImage!, into: cell.bookImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let whatToSpeak2 = self.books[indexPath.row]["title"].stringValue
        SpeechService.shared.speak(text: whatToSpeak2, voiceType: .waveNetFemale) {
            print("Reading music")
        }
    }

}
