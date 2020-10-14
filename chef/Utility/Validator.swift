//
//  Validator.swift
//  chef
//
//  Created by Akshay Raiyani on 03/01/20.
//  Copyright © 2020 MacBook Pro. All rights reserved.
//

import Foundation
class Validator: NSObject {
     
     // Max length of an email is restricted to 50
     class func validateEmail(_ strEmail:String) -> Bool {
          
          let trimmedString = strEmail.trimmingCharacters(in: CharacterSet.whitespaces)
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          let result = emailTest.evaluate(with: trimmedString)
          //Max length 50
          if(strEmail.count <= 50 && result){
               return true;
          }
          return false;
     }
     
     // By default Phone number range is 8 to 12
     class func validatePhoneNumber(_ strPhoneNumber: String) -> Bool {
          return self.validatePhoneNumber(strPhoneNumber, withMinLength: 10, withMaxLength: 15);
     }
     
     class func validatePhoneNumber(_ strPhoneNumber: String, withMinLength min: Int, withMaxLength max: Int) -> Bool{
          
          if(strPhoneNumber.count >= min && strPhoneNumber.count <= max){
               let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
               var filtered:NSString!
               let inputString:NSArray = strPhoneNumber.components(separatedBy: charcter) as NSArray
            filtered = inputString.componentsJoined(by: "") as NSString?
            return  strPhoneNumber as NSString? == filtered
          }else{
               return false;
          }
     }

     //Length check and null check
     class func isStringEmptyOrNull(_ string : String) -> Bool{
          if(string.count > 0  && string != "null"){
               return true;
          }else{
               return false;
          }
     }
     
     class func isPasswordSame(_ strPassword: String , strConfirmPassword : String) -> Bool {
          
          if strPassword == strConfirmPassword
          {
               return true
          }else
          {
               return false
          }
     }
     
     // Validation of password, by dafult range is 8 to 25
     class func validatePassWord(_ strPassword : String) -> Bool{
          return self.validatePassword(strPassword, withMin: 6, withMax: 25);
     }
     
     class func validatePassword(_ strPassword: String, withMin min : Int, withMax max : Int ) -> Bool {
          return self.validatePassword(strPassword, withMin: min, withMax: max, minUpperCase: 0, containsSpecialChar: false, minDigit: 0);
     }
     
     class func validatePassword(_ strPassword: String, withMin min : Int, withMax max : Int, minUpperCase : Int, containsSpecialChar : Bool, minDigit : Int) -> Bool{
          
          var isUpperCase = Bool()
          var isSpecial = Bool()
          var isDigit = Bool()
          
          var upperCount : Int = 0;
          var digitCount : Int = 0;
          
          /// For Upper case letter
          if(minUpperCase > 0){
               for chr in strPassword {
                    let str = String(chr)
                    if str.lowercased() != str {
                         upperCount += 1
                    }
                    if(upperCount == minUpperCase){
                         isUpperCase = true
                    }
               }
          }else{
               isUpperCase = true;
          }
          
          
          //For special Char
          if(containsSpecialChar){
               let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
               if regex.firstMatch(in: strPassword, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, strPassword.count)) != nil {
                    //printLog("Special characters found")
                    isSpecial = true;
               }
          }else{
               isSpecial = true;
          }
          
          // For digit
          if(minDigit > 0){
               let digitString = "0123456789";
               
               for chr in strPassword {
                    let str = String(chr)
                    if (digitString.contains(str)) {
                         digitCount += 1
                    }
                    
                    if(digitCount == minDigit){
                         isDigit = true;
                    }
               }
          }else{
               isDigit = true
          }
          
          
          // Final check
          if(isSpecial && isUpperCase && strPassword.count >= min && strPassword.count <= max && isDigit){
               return true
          }else{
               return false
          }
     }
     
     class func namelValidation(_ name:String)->Bool{
          //var nameRegex = "[A-Za-z]{4,50}"
          let nameRegex = "[A-Za-z]"
          let nameTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
          return nameTest.evaluate(with: name)
     }
     
     class func isNumeric(_ matchCharacters: String) -> Bool
     {
          let scanner = Scanner(string: matchCharacters)
          scanner.locale = Locale.current
          
          return scanner.scanDecimal(nil) && scanner.isAtEnd
     }
    class func validateCreditCardNumber(cardnumber:String) -> (name: String?, isValid: Bool)
    {
        let VisaRegex = "^4[0-9]{6,}$"
        let MasterCardRegex = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
        let AmericanRegex = "^3[47][0-9]{13}$"
        let DiscoverRegex = "^6(?:011|5[0-9]{2})[0-9]{12}$"
        let JCBRegex = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        
        let cardType = ["visa","mastercard","amex","discover","jcb"]
        let cardRegex = [VisaRegex,MasterCardRegex,AmericanRegex,DiscoverRegex,JCBRegex]
        
        var fl = false
        for i in 0 ..< cardRegex.count {
            let regex = cardRegex[i]
            let passTest = NSPredicate(format:"SELF MATCHES %@", regex)
            let result = passTest.evaluate(with: cardnumber)
            if(result == true){
                fl = true
                return (cardType[i],fl)
            }
        }
        
        if(fl == false){
            return (nil,fl)
        }
    }
}
