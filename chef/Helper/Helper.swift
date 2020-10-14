//
//  Helper.swift
//  chef
//
//  Created by Eddie Ha on 23/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import CoreLocation

class Helper: NSObject {
    
    static let ErrorMessage = "We can't connect to the network, internet, or server at the moment, kindly try again later"
    
    //masking view
    static func maskView(_ view: UIView?, topLeftRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat, topRightRadius: CGFloat, width: CGFloat, height: CGFloat) {
        
        let minx: CGFloat = 0
        let miny: CGFloat = 0
        let maxx = width
        let maxy = height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: minx + topLeftRadius, y: miny))
        path.addLine(to: CGPoint(x: maxx - topRightRadius, y: miny))
        path.addArc(withCenter: CGPoint(x: maxx - topRightRadius, y: miny + topRightRadius), radius: topRightRadius, startAngle: CGFloat(3 * M_PI_2), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: maxx, y: maxy - bottomRightRadius))
        path.addArc(withCenter: CGPoint(x: maxx - bottomRightRadius, y: maxy - bottomRightRadius), radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addLine(to: CGPoint(x: minx + bottomLeftRadius, y: maxy))
        path.addArc(withCenter: CGPoint(x: minx + bottomLeftRadius, y: maxy - bottomLeftRadius), radius: bottomLeftRadius, startAngle: CGFloat(M_PI_2), endAngle: .pi, clockwise: true)
        path.addLine(to: CGPoint(x: minx, y: miny + topLeftRadius))
        path.addArc(withCenter: CGPoint(x: minx + topLeftRadius, y: miny + topLeftRadius), radius: topLeftRadius, startAngle: .pi, endAngle: CGFloat(3 * M_PI_2), clockwise: true)
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view?.layer.mask = maskLayer
    }
    
    
    //masking view
    static func maskViewWithElevation(_ view: UIView?, topLeftRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat, topRightRadius: CGFloat, width: CGFloat, height: CGFloat, elevation: CGFloat) {
        
        let minx: CGFloat = 0
        let miny: CGFloat = 0
        let maxx = width
        let maxy = height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: minx + topLeftRadius, y: miny))
        path.addLine(to: CGPoint(x: maxx - topRightRadius, y: miny))
        path.addArc(withCenter: CGPoint(x: maxx - topRightRadius, y: miny + topRightRadius), radius: topRightRadius, startAngle: CGFloat(3 * M_PI_2), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: maxx, y: maxy - bottomRightRadius))
        path.addArc(withCenter: CGPoint(x: maxx - bottomRightRadius, y: maxy - bottomRightRadius), radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addLine(to: CGPoint(x: minx + bottomLeftRadius, y: maxy))
        path.addArc(withCenter: CGPoint(x: minx + bottomLeftRadius, y: maxy - bottomLeftRadius), radius: bottomLeftRadius, startAngle: CGFloat(M_PI_2), endAngle: .pi, clockwise: true)
        path.addLine(to: CGPoint(x: minx, y: miny + topLeftRadius))
        path.addArc(withCenter: CGPoint(x: minx + topLeftRadius, y: miny + topLeftRadius), radius: topLeftRadius, startAngle: .pi, endAngle: CGFloat(3 * M_PI_2), clockwise: true)
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.shadowPath = path.cgPath
        maskLayer.shadowColor = UIColor.black.cgColor
        maskLayer.shadowOffset = CGSize(width: 0, height: elevation)
        maskLayer.shadowRadius = elevation
        maskLayer.shadowOpacity = 0.24
        view?.layer.mask = maskLayer
    }
    
    
    //masking view with border
    static func maskView(withBorder view: UIView?, topLeftRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat, topRightRadius: CGFloat, width: CGFloat, height: CGFloat, color: UIColor?) {
        
        let minx: CGFloat = 0
        let miny: CGFloat = 0
        let maxx = width
        let maxy = height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: minx + topLeftRadius, y: miny))
        path.addLine(to: CGPoint(x: maxx - topRightRadius, y: miny))
        path.addArc(withCenter: CGPoint(x: maxx - topRightRadius, y: miny + topRightRadius), radius: topRightRadius, startAngle: CGFloat(3 * M_PI_2), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: maxx, y: maxy - bottomRightRadius))
        path.addArc(withCenter: CGPoint(x: maxx - bottomRightRadius, y: maxy - bottomRightRadius), radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addLine(to: CGPoint(x: minx + bottomLeftRadius, y: maxy))
        path.addArc(withCenter: CGPoint(x: minx + bottomLeftRadius, y: maxy - bottomLeftRadius), radius: bottomLeftRadius, startAngle: CGFloat(M_PI_2), endAngle: .pi, clockwise: true)
        path.addLine(to: CGPoint(x: minx, y: miny + topLeftRadius))
        path.addArc(withCenter: CGPoint(x: minx + topLeftRadius, y: miny + topLeftRadius), radius: topLeftRadius, startAngle: .pi, endAngle: CGFloat(3 * M_PI_2), clockwise: true)
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view?.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color?.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = view?.bounds ?? CGRect.zero
        view?.layer.addSublayer(borderLayer)
    }
    
    //get text height
    public static func getTextHeight(text: String, width:CGFloat) -> CGFloat {
        
        if (text == "") || text == nil || text == nil {
            return 0
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = text
        label.sizeToFit()
        
        return (label.frame.size.height)
    }
    
    //get text width
    public static func getTextWidth(text: String, height:CGFloat) -> CGFloat {
        
        if (text == "") || text == nil || text == nil {
            return 0
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width:0, height: height))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = text
        label.sizeToFit()
        
        return (label.frame.size.width)
    }
    
    //----------------------------------------------------------------------
    // MARK:- Check Email Validity
    //----------------------------------------------------------------------
    
    static func isValidEmail(for emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    static func loggedIn(state: Bool) {
        UserDefaults.standard.set(state, forKey: SaveKeys.isLogin.rawValue)
    }
    
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: SaveKeys.isLogin.rawValue)
    }
    
    static func saveUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: SaveKeys.token.rawValue)
    }
    
    static func getUserToken() -> String {
        let token = UserDefaults.standard.value(forKey: SaveKeys.token.rawValue) as? String
        return token ?? ""
    }
    
}

enum SaveKeys: String {
    case isLogin
    case token
}

func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String , completionHandler: @escaping (String) -> Void)-> Void {
    
    var Final_address = String()
    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
    let lat: Double = Double("\(pdblLatitude)") ?? 0.0
    //21.228124
    let lon: Double = Double("\(pdblLongitude)") ?? 0.0
    //72.833770
    let ceo: CLGeocoder = CLGeocoder()
    center.latitude = lat
    center.longitude = lon

    let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


    ceo.reverseGeocodeLocation(loc, completionHandler:
        {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]

            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                Final_address = "\(pm.postalCode ?? "") \(pm.thoroughfare ?? ""),\(pm.subLocality ?? "")"
                completionHandler(Final_address)
          }
            
    })
    
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
