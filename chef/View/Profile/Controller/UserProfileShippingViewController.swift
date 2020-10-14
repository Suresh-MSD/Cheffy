//
//  UserProfileShippingViewController.swift
//  chef
//
//  Created by Eddie Ha on 2/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import MapKit
import SkyFloatingLabelTextField
import SwiftyJSON
import GooglePlaces
import GoogleMaps
import GooglePlacePicker

class UserProfileShippingViewController: BaseViewController,UITextViewDelegate {
    
    //MARK: Properties
    public let CLASS_NAME = UserProfileShippingViewController.self.description()
    private let userProfileService = UserProfileService.getInstance()
    
    //MARK: Outlets
    @IBOutlet weak var mvCurrentLocation: GMSMapView!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    
    @IBOutlet weak var DeliveryNoteText: UITextView!
    @IBOutlet weak var Lbl_Title: UILabel!
    @IBOutlet weak var Address1_TextField: SkyFloatingLabelTextField!
    @IBOutlet weak var Address2_TextField: SkyFloatingLabelTextField!
    @IBOutlet weak var Zipcode_TextField: SkyFloatingLabelTextField!
    
    // Edit
    var IsEdit = false
    var EditUserShippingAddress = UserShippingAddress()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DeliveryNoteText.text = "My special delivery instructions"
        DeliveryNoteText.textColor = UIColor.lightGray
        DeliveryNoteText.delegate = self
        // Do any additional setup after loading the view.
        
        if IsEdit {
            
            Lbl_Title.text = "Edit Address"
            Current_Lat_Long.latitude = Double(EditUserShippingAddress.lattitude ?? "")!
            Current_Lat_Long.longitude = Double(EditUserShippingAddress.longitude ?? "")!
            locality = EditUserShippingAddress.city ?? ""
            UserState = EditUserShippingAddress.state ?? ""
            mvCurrentLocation.camera = GMSCameraPosition.camera(withLatitude: Current_Lat_Long.latitude, longitude: Current_Lat_Long.longitude, zoom: 6.0)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Current_Lat_Long.latitude, longitude: Current_Lat_Long.longitude))
            
            
            if EditUserShippingAddress.addressLine1 != "" || EditUserShippingAddress.addressLine2 != "" {
                lblCurrentLocation.text = "\(EditUserShippingAddress.addressLine1 ?? "") ,\(EditUserShippingAddress.addressLine2 ?? "")"
                marker.title = EditUserShippingAddress.addressLine1 ?? ""
                marker.snippet = EditUserShippingAddress.addressLine2 ?? ""
            } else {
                lblCurrentLocation.text = "\(EditUserShippingAddress.city ?? "") , \(EditUserShippingAddress.state ?? "")"
                marker.title = EditUserShippingAddress.city ?? ""
                marker.snippet = EditUserShippingAddress.state ?? ""
            }
            
            marker.map = mvCurrentLocation
            
            Address1_TextField.text = EditUserShippingAddress.addressLine1 ?? ""
            Address2_TextField.text = EditUserShippingAddress.addressLine2
                ?? ""
            DeliveryNoteText.text = EditUserShippingAddress.deliveryNote
            Zipcode_TextField.text = EditUserShippingAddress.zipCode ?? ""
            
            if DeliveryNoteText.text.isEmpty {
                DeliveryNoteText.text = "My special delivery instructions"
                DeliveryNoteText.textColor = UIColor.lightGray
            } else {
                DeliveryNoteText.textColor = UIColor.black
            }
            
        } else {
            
            Lbl_Title.text = "Add New Address"
            let User_Location = LocationService().UserLocation?.coordinate
            mvCurrentLocation.camera = GMSCameraPosition.camera(withLatitude: User_Location?.latitude ?? 0.0, longitude: User_Location?.longitude ?? 0.0, zoom: 6.0)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: User_Location?.latitude ?? 0.0, longitude: User_Location?.longitude ?? 0.0))
            marker.map = mvCurrentLocation
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @IBAction func PlacePicker(_ sender: UIButton) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    //MARK: Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "My special delivery instructions"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //MARK: Actions
    //when click on back button
    @IBAction func onClickbackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnClickSave(_ sender: UIButton) {
        
        self.newShippingAddress()
    }
    
    //MARK: Instance Method
    private func newShippingAddress() {
        
        if Address1_TextField.text == "" || Address2_TextField.text == "" || Zipcode_TextField.text == "" || DeliveryNoteText.text == "" || DeliveryNoteText.text == "My special delivery instructions" {
            showMessageWith("", "Enter valid address", .warning)
            return
        }
//        else if locality == "" || UserState == "" {
//            showMessageWith("", "Select location", .warning)
//            return
//        }
        
        ProgressViewHelper.show(type: .full)
        
        let url = IsEdit ? ApiEndpoints.URI_UPDATE_USER_SHIPPING_ADRESS + "/\(EditUserShippingAddress.id ?? 0)" : ApiEndpoints.URI_POST_USER_SHIPPING_ADRESS
        
        
        let parameters: [String: Any] = [
            "addressLine1": "\(Address1_TextField.text ?? "")",
            "addressLine2": "\(Address2_TextField.text ?? "")",
            "city": locality,
            "state": UserState,
            "zipCode": "\(Zipcode_TextField.text ?? "")",
            "lat": "\(Current_Lat_Long.latitude)",
            "lon": "\(Current_Lat_Long.longitude)",
            "deliveryNote":"\(DeliveryNoteText.text!)",
            "isDefaultAddress": IsEdit ? false : true
        ]
        
        if IsEdit {
            
            userProfileService.EditUserShippingAddress(url: url, parameters: parameters) { (response) in
                
                ProgressViewHelper.hide()
                
                let json = JSON(response.data!)
                print(json)
                let item = json["data"].dictionaryValue
                if !item.isEmpty{
                    let MSG = json["message"].string
                    self.showMessageWith("",MSG, .success)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        } else {
            userProfileService.postUserShippingAddress(url: url, parameters: parameters) { (response) in
                
                ProgressViewHelper.hide()
                
                let json = JSON(response.data!)
                print(json)
                let item = json["data"].dictionaryValue
                if !item.isEmpty{
                    let MSG = json["message"].string
                    self.showMessageWith("",MSG, .success)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showMessageWith("Error", Helper.ErrorMessage, .error)
                }
            }
        }
    }
    
    func fillAddressForm() {
        
        Address1_TextField.text = street_number + " " + route
        print("Address ==>> \(street_number + " " + route)")
        print("City ==>> \(locality)")
        print("State ==>> \(UserState)")
        if postal_code_suffix != "" {
            Zipcode_TextField.text = postal_code + "-" + postal_code_suffix
        } else {
            Zipcode_TextField.text = postal_code
        }
        
        if street_number == "" {
            lblCurrentLocation.text = locality + "," + UserState + "," + country
        } else {
            lblCurrentLocation.text = street_number + " " + route + "," + locality + "," + UserState
        }
        
        mvCurrentLocation.camera = GMSCameraPosition.camera(withLatitude: Current_Lat_Long.latitude, longitude: Current_Lat_Long.longitude, zoom: 6.0)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Current_Lat_Long.latitude, longitude: Current_Lat_Long.longitude))
        
        if street_number == "" {
            marker.title = locality + "," + UserState
            marker.snippet = country
        } else {
            marker.title = street_number + " " + route
                   marker.snippet = locality
        }
        marker.map = mvCurrentLocation
    }
}


// Declare variables to hold address form values.
var street_number: String = ""
var route: String = ""
var neighborhood: String = ""
var locality: String = ""
var UserState: String = ""
var country: String = ""
var postal_code: String = ""
var postal_code_suffix: String = ""
var Current_Lat_Long = CLLocationCoordinate2D()

extension UserProfileShippingViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        
        let Add = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        Current_Lat_Long = Add
        
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeNeighborhood:
                    neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    UserState = field.name
                case kGMSPlaceTypeCountry:
                    country = field.name
                case kGMSPlaceTypePostalCode:
                    postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        
        self.fillAddressForm()
        
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error.localizedDescription)")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}
