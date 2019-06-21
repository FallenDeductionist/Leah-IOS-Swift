//
//  NewsViewController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/18/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke

class NewsCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var datePublicLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
}


class NewsVariables {
    private init() {}
    static let shared = NewsVariables()
    
    var URLApi = "https://newsapi.org/v2/top-headlines"
    var params = ["apiKey":"", "category":"technology", "country":"us"]
    var defaultNewBg = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF_Orod47mzB0CfnUASBPMxN8-Rro_lXfUKqYX2VJWLkF_xpM4A"
}


class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var weatherIcon1: UIImageView!
    @IBOutlet weak var weatherIcon2: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var news = [JSON]()
    var newsCell = NewsCell()
    
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
            
            self.getWeather(url: WeatherVariables.shared.URLApi, params: WeatherVariables.shared.params, completion: {_ in
                self.welcomeLabel.text = "Bienvenido: " + APIvariables.shared.appName
                self.weatherLabel.text = "Lima, " + WeatherVariables.shared.condition + ", " + WeatherVariables.shared.temperature + "º C"
                self.dayLabel.text = dayInWeek
                self.dateLabel.text = dateSpanish
                let pathForWeather = WeatherVariables.shared.icon.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                let parsedOneWth = "https:" + pathForWeather!
                loadImage(with: URL(string: parsedOneWth)!, into: self.weatherIcon2)
                loadImage(with: URL(string: parsedOneWth)!, into: self.weatherIcon1)
                
                loadImage(with: imageURL!, into: self.profileImage)
                
                let whatToSpeak = "Welcome " + APIvariables.shared.appName + ". The weather condition for today is " + WeatherVariables.shared.condition + " at temperature " + WeatherVariables.shared.temperature + " grades"
                
                SpeechService.shared.speak(text: whatToSpeak, voiceType: .waveNetFemale) {
                    print("completed speech")
                    let whatToSpeak2 = "Whats on the news?. " + self.news[0]["title"].stringValue
                    SpeechService.shared.speak(text: whatToSpeak2, voiceType: .waveNetFemale) {
                        print("Reading news")
                    }
                }
                
                
            })
            self.getNews(url: NewsVariables.shared.URLApi, params: NewsVariables.shared.params, completion: {_ in
                self.tableView.reloadData()
                self.tableView.delegate = self
                self.tableView.dataSource = self
            })
        }
    }
    
    func getWeather(url: String, params: [String:String], completion: @escaping(Any?)-> Void){
        Alamofire.request(url, method: .get, parameters: params).validate().responseJSON{ response in
            if response.result.isSuccess{
                print("Succes Forecast")
                let weatherJSON = JSON(response.result.value!)
                WeatherVariables.shared.temperature = weatherJSON["current"]["temp_c"].stringValue
                WeatherVariables.shared.condition = weatherJSON["current"]["condition"]["text"].stringValue
                WeatherVariables.shared.icon = weatherJSON["current"]["condition"]["icon"].stringValue
                completion(weatherJSON)
            }
            
        }
    }
    
    func getNews(url: String, params:   [String:String], completion: @escaping(Any?)-> Void){
        Alamofire.request(url, method: .get, parameters: params).validate().responseJSON {
            response in
            if response.result.isSuccess{
                print("Succes man")
                let newsJSON = JSON(response.result.value!)
                for i in 0..<10{
                    let content = newsJSON["articles"][i]
                    self.news.append(content)
                    print(content)
                }
                completion(self.news)
                print(self.news)
            }
            else{
                print("------------------didnatesdasd sdasdasvdsvdasdsad")
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"
        let limitDate = self.news[indexPath.row]["publishedAt"].stringValue
        let formattedDate = dateFormatter.date(from: limitDate)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let customDate = dateFormatter.string(from: formattedDate!)
        let okMan = self.news[indexPath.row]["urlToImage"].stringValue
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
        cell.titleLabel?.text = self.news[indexPath.row]["title"].stringValue
        cell.titleLabel.sizeToFit()
        
        cell.datePublicLabel?.text = customDate
        
        cell.contentLabel.numberOfLines = 0
        cell.contentLabel.lineBreakMode = .byWordWrapping
        cell.contentLabel?.text = self.news[indexPath.row]["description"].stringValue
        loadImage(with: urlNewImage!, into: cell.backgroundImage)
        cell.contentLabel.sizeToFit()
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.7) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: cell.backgroundImage.frame.width, height: cell.backgroundImage.frame.height)
        
        cell.backgroundImage.addSubview(tintView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let whatToSpeak2 = "Next: " + self.news[indexPath.row]["title"].stringValue
        SpeechService.shared.speak(text: whatToSpeak2, voiceType: .waveNetFemale) {
            print("Reading music")
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: nil)
    }
    

}
