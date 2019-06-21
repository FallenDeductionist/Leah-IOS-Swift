//
//  MusicViewController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/19/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke

class MusicVariables {
    private init() {}
    static let shared = MusicVariables()
    
    var URLApi = "https://api.spotify.com/v1/playlists/37i9dQZF1DWWEJlAGA9gs0/tracks"
    var params = ["limit":"20"]
    var headers = ["Authorization":"Bearer "]
}
class MusicCell: UITableViewCell{
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
}

class MusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var weatherIcon1: UIImageView!
    @IBOutlet weak var weatherIcon2: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var songs = [JSON]()
    var albums = [JSON]()
    
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
                    let whatToSpeak2 = "A song you may like. " + self.songs[2]["name"].stringValue
                    SpeechService.shared.speak(text: whatToSpeak2, voiceType: .waveNetFemale) {
                        print("Reading music")
                    }
                }
                
                
            })
            self.getSongs(url: MusicVariables.shared.URLApi, params: MusicVariables.shared.params, headers: MusicVariables.shared.headers,completion: {_ in
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
    
    func getSongs(url: String, params:   [String:String], headers: [String:String], completion: @escaping(Any?)-> Void){
        Alamofire.request(url, method: .get, parameters: params, headers: headers).validate().responseJSON {
            response in
            if response.result.isSuccess{
                print("Succes spotify")
                let musicJSON = JSON(response.result.value!)
                for i in 0..<21{
                    let content = musicJSON["items"][i]["track"]
                    self.songs.append(content)
                    let content2 = musicJSON["items"][i]["track"]["album"]
                    self.albums.append(content2)
                }
                completion(self.songs)
                print(self.songs)
            }
            else{
                print("------------------didnatesdasd sdasdasvdsvdasdsad")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! MusicCell
        
        let okMan = self.songs[indexPath.row]["album"]["images"][0]["url"].stringValue
        var meDammit = ""
        if okMan.isEmpty {
            meDammit = NewsVariables.shared.defaultNewBg.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        }
        else{
            meDammit = okMan.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        }
        
        let urlNewImage = URL(string: meDammit)
        
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.lineBreakMode = .byWordWrapping
        cell.nameLabel?.text = self.songs[indexPath.row]["name"].stringValue
        cell.nameLabel.sizeToFit()
        
        cell.albumLabel.numberOfLines = 0
        cell.albumLabel.lineBreakMode = .byWordWrapping
        cell.albumLabel?.text = self.albums[indexPath.row]["name"].stringValue
        
        cell.artistLabel.numberOfLines = 0
        cell.artistLabel.lineBreakMode = .byWordWrapping
        cell.artistLabel?.text = self.songs[indexPath.row]["artists"][0]["name"].stringValue
        cell.artistLabel.sizeToFit()
        
        
        loadImage(with: urlNewImage!, into: cell.albumImage)
        
        cell.albumLabel.sizeToFit()
        
        loadImage(with: urlNewImage!, into: cell.backgroundImage)
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.7) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: cell.backgroundImage.frame.width, height: cell.backgroundImage.frame.height)
        
        cell.backgroundImage.addSubview(tintView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let whatToSpeak2 = self.songs[indexPath.row]["name"].stringValue + " performed by " + self.songs[indexPath.row]["artists"][0]["name"].stringValue
        SpeechService.shared.speak(text: whatToSpeak2, voiceType: .standardFemale) {
            print("Reading music")
        }
    }
    @IBAction func logout(_ sender: Any) {
        performSegue(withIdentifier: "logout2", sender: nil)
    }
    
}
