//
//  ViewController.swift
//  locationSunrise
//
//  Created on 2020/04/02.
//  Copyright © 2020 KG. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var lat:String = ""
    var lon:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    @IBOutlet weak var outputSunrise: UILabel!
    
    @IBAction func searchQuery(_ sender: Any) {
        _ = Date()
                
        let cal = Calendar.current
        let comp = cal.dateComponents(
        [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,
        Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second],
        from: Date())
                
        //comp.year,month,day,hour,minute,second
        let tmpYear:Int = Int(comp.year!)
        let tmpMonth:Int = Int(comp.month!)
        let tmpDay:Int = Int(comp.day!)
        let tmpHour:Int = Int(comp.hour!)

        getURL(y: tmpYear, m: tmpMonth, d: tmpDay, h: tmpHour)
    }

    func getURL(y: Int, m:Int, d:Int, h:Int) {
        let setURL:String = "https://mgpn2.sakura.ne.jp/api/sun/position.cgi?json&y=\(y)&m=\(m)&d=\(d)&h=\(h)&lat=\(lat)&lon=\(lon)"
        do {
            let requestURL = URL(string:setURL)!
            let data = try Data(contentsOf: requestURL)
            let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String,Any>
            let query = json["result"] as! [String:Any]
            let tmpSunriseTime = query["sunrise"] as! NSString
            let sunriseString:String = tmpSunriseTime as String
            
            self.outputSunrise.text = "日の出時刻:\(sunriseString.suffix(5))"
            
        } catch {
            self.outputSunrise.text = "Some error has occurred."

        }
    }

    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()

        let status = CLLocationManager.authorizationStatus()

        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func showAlert() {
        let alertTitle = "Invalid location service."
        let alertMessage = "Please change from [Privacy> Location Services] in the Settings app."
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        self.lat = String(latitude!)
        self.lon = String(longitude!)
    }
}
