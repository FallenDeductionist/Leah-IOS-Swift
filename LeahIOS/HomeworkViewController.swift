//
//  HomeworkViewController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/17/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke

class homeworkCell: UITableViewCell {
    @IBOutlet weak var homeworkTitle: UILabel!
    @IBOutlet weak var homeworkDescripcion: UILabel!
    @IBOutlet weak var homeworkLimit: UILabel!
    @IBOutlet weak var homeworkKeywords: UILabel!
    
}

class WeatherVariables {
    private init() {}
    static let shared = WeatherVariables()
    
    var URLApi = "https://api.apixu.com/v1/current.json"
    var params = ["key":"", "q":"Lima", "lang":"en"]
    var temperature = ""
    var condition = ""
    var icon = ""
    
}

class HomeworkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon2: UIImageView!
    @IBOutlet weak var wetherIcon: UIImageView!
    
    var homework = [JSON]()
    var keywords = [[String]]()
    var homeworkCellContent = homeworkCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let token = "bearer " + APIvariables.shared.token
        let userId = APIvariables.shared.idUser
        let uri = APIvariables.shared.URLApi + "homeworks/" + userId
        let headers = ["Authorization": token]
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
                loadImage(with: URL(string: parsedOneWth)!, into: self.wetherIcon)
    
                self.tableView.reloadData()
                loadImage(with: imageURL!, into: self.profileImage)
                self.getHomeworks(url: uri, headers: headers){_ in
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                }
            })
            
            
        }
        
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homework.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! homeworkCell
        var union = ""
        var arrUnion = [String]()
        let keywordAccess = self.homework[indexPath.row]["keyword"]
        for i in 0..<keywordAccess.count{
            union = "\(keywordAccess[i]["word"])"
            arrUnion.append(union)
        }
        self.keywords.append(arrUnion)
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let limitDate = self.homework[indexPath.row]["date"].stringValue
        let formattedDate = dateFormatter.date(from: limitDate)
        dateFormatter.dateFormat = "dd/MM HH:mm"
        let customDate = dateFormatter.string(from: formattedDate!)
        
        
        cell.homeworkTitle?.text = self.homework[indexPath.row]["title"].stringValue
        cell.homeworkLimit?.text = "Límite: \(customDate)"
        cell.homeworkDescripcion?.text = self.homework[indexPath.row]["description"].stringValue
        cell.homeworkKeywords?.text = "keywords:  \(self.keywords[indexPath.row].joined(separator: ","))"
        //cell.homeworkTitle?.text = homework[1]["title"].stringValue
        //cell.homeworkLimit?.text = "Límite: " + homework[1]["date"].stringValue
        //cell.homeworkDescripcion?.text = homework[1]["description"].stringValue
        print(self.keywords)
        return cell
    }
    
    func getHomeworks(url: String, headers:   [String:String], completion: @escaping(Any?)-> Void){
        Alamofire.request(url, method: .get, headers: headers).validate().responseJSON {
            response in
            if response.result.isSuccess{
                print("Succes man")
                let homeworkJSON = JSON(response.result.value!)
                let counter = homeworkJSON["count"].intValue
                for i in 0..<counter{
                    let content = homeworkJSON["homeworks"][i]
                    self.homework.append(content)
                }
                completion(self.homework)
            }
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
    
    @IBAction func microTapped(_ sender: Any) {
        let whatToSpeak = "Your " + self.homework[0]["title"].stringValue + " is still pending"
        SpeechService.shared.speak(text: whatToSpeak, voiceType: .waveNetFemale) {
            self.speakButton.isEnabled = true
            self.speakButton.alpha = 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let whatToSpeak2 = "Your " + self.homework[indexPath.row]["title"].stringValue + " is still pending"
        SpeechService.shared.speak(text: whatToSpeak2, voiceType: .waveNetFemale) {
            print("Reading music")
        }
    }
    
}
