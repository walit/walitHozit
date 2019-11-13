//
//  Constants.swift
//  Lysten
//
//  Created by owner on 16/11/17.
//

import Foundation
import UIKit
import SystemConfiguration

struct myColors
{
    static let AppThemeColor: UIColor = UIColor(red: 153.0/255.0, green: 174.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    static let BlueColor: UIColor = UIColor(red: 69.0/255.0, green: 117.0/255.0, blue: 171.0/255.0, alpha: 1.0)
    static let BlueButtonColor: UIColor = UIColor(rgb: 0x26235f, a: 1.0)
    static let PlaceHolderTextColor: UIColor = UIColor(rgb: 0x7e7e7e, a: 1.0)
    static let MenuBGColor: UIColor = UIColor(rgb: 0x4575ab, a: 1.0)
    static let NavigatorBGColor: UIColor = UIColor(rgb: 0xA0A826, a: 1.0)
    static let CallRequestDeselected: UIColor = UIColor(rgb: 0x7B7B7B, a: 1.0)
    static let gradientLow: UIColor = UIColor(rgb: 0xff6600, a: 1.0)
    static let gradientHigh: UIColor = UIColor(rgb: 0xf09826, a: 1.0)
    static let AppThemeOrange: UIColor = UIColor(rgb: 0xEB9D2C, a: 1.0)
    static let AppThemePurple: UIColor = UIColor(rgb: 0x364190, a: 1.0)
    static let BubbleGray: UIColor = UIColor(rgb: 0xE5E6EA, a: 1.0)
    static let tabGray: UIColor = UIColor(rgb: 0x8a8a8f, a: 1.0)
    static let borderColor: UIColor = UIColor(rgb: 0xD1D1D1, a: 1.0)

}

struct myStrings
{
    static let KUDLOGINSTATUS = "KLogin"
    static let KLOGIN = "KLogin"
    static let KUSERID = "KUserID"
    static let KUSERNAME = "KUserName"
    static let KUSERIMAGE = "KUserImage"
    static let KACCESSTOKEN = "KAccessToken"

}

struct Padding
{
    static let KHEIGHT = 40.0
    static let KLEADING = 50.0
    static let KCONTAINER = 220.0

}

struct myURLs
{

    static let stagingURL = "http://walit.net/api/howzit/v1/index.php/"
    static let liveURL = "http://walit.net/api/howzit/v1/index.php/"
    
    static let baseSocketURL = "http://35.239.79.227:2021"
}
struct ApiNames
{
    static let VUserAuth = "UserAuth"
    static let VGetRecentChat = "GetRecentChat"
    static let VGetContacts = "GetContacts"
    static let VGetMessages = "GetMessages"
    static let VSendMessage = "SendMessage"
    static let VGetStatus = "GetCurrentStatusNew"
}

var strUserName = ""
var strToUserId = ""
var strCardToken = ""
var strCallingRequestId = ""
var strCallingImage : UIImage = UIImage()
var strToImage = ""

struct StaticNameOfVariable
{
    // User SignIn

    static let VdeviceID = "DEVICE-ID"
    static let Vcode = "code"
    static let Vdata = "data"
    static let VAccessToken = "access_token"
    static let VCount = "Count"
    static let VCountSmall = "count"
    static let VtotalCount = "TotalCount"
    static let VDeviceToken = "DeviceToken"
    static let VStatus = "status"
    static let Vmessage = "message"
    static let VUserID = "user_id"
    static let Vfirstname = "first_name"
    static let Vlastname = "last_name"
    static let Vimage = "image"
    static let VACCESSTOKEN = "ACCESS-TOKEN"
    static let VContacts = "contacts"
    static let Vmessage_type = "message_type"
    static let VreceiverUserId = "receiver_user_id"
    static let Vdate_time = "date_time"
    static let Vtime_zone = "time_zone"
    static let Vmessage_id = "message_id"
    static let Vis_read = "is_read"
}


struct StatusCode
{
    static let codeOk = 200
    static let codeTokenValidationFailed = 401
    static let codecodeBadrequest = 400
    static let statusCodeOk = "OK"
    static let codeNovalue = 302
    static let codeDealCompleted = 303
    static let fail = "fail"
    static let success = "success"
}

struct StatusErrorMessade {
    
    static let response_message = "message"
    static let response_TokenFail = "ReasonPhrase"

}

struct myMessages
{
    static let INTERNET_CONNECTIVITY_FAIL = "Please check your internet connection and try again"
    static let ERROR = "Error!"
    static let WARNING = "Warning!"
    static let CONGRATULATION = "Congratulations!"
    static let SUCCESSFUL = "Successful!"
    static let kAlertMsgSomethingWentWrong = "Something went wrong..."

}

struct Miscellaneous
{
    static let APPDELEGATE  = UIApplication.shared.delegate as! AppDelegate
}

extension String {
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func insertSpace(string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
}

extension UIViewController {
    
    func addGradientWithColor(){
        
        if let theView = self.view.viewWithTag(999) {
            
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = theView.frame.size
            gradientLayer.colors = [myColors.gradientLow.cgColor, myColors.gradientHigh.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            theView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
    
}


extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}

extension UIViewController {
    
    func previousViewController() -> UIViewController? {
       let numberOfViewControllers = self.navigationController!.viewControllers.count
        if numberOfViewControllers > 2{
            return self.navigationController!.viewControllers[numberOfViewControllers - 2] as UIViewController
        }
        else{
            return nil
        }
    }
}

extension NSObject {
    
    func makeMyToastActivity() -> Void {
        UIApplication.shared.beginIgnoringInteractionEvents()
      
        Global.sharedInstance.activityIndicatorView.color = myColors.AppThemeOrange
        Global.sharedInstance.activityIndicatorView.center = Miscellaneous.APPDELEGATE.window!.center
        Miscellaneous.APPDELEGATE.window!.addSubview(Global.sharedInstance.activityIndicatorView)
        
        DispatchQueue.main.async(execute: {
            Global.sharedInstance.activityIndicatorView.startAnimating()
        })
        
    }
    func stopMyToastActivity() -> Void {
        DispatchQueue.main.async {
             UIApplication.shared.endIgnoringInteractionEvents()
            Global.sharedInstance.activityIndicatorView.stopAnimating()
        }
        
    }
    
    
    func showAlertFor(alertTitle : String, alertMessage : String) -> Void {
        
        let alert:UIAlertController=UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let cameraAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        DispatchQueue.main.async {
         UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func makeMyExclusiveToast(alertTitle : String, alertMessage : String) -> Void
    {
        let alert:UIAlertController=UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let cameraAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

extension UITextField {
    
    func setPlaceHolderString(mystring : String) -> Void {
        let placeholderFirstName = NSAttributedString(string: mystring, attributes: [NSAttributedString.Key.foregroundColor : myColors.PlaceHolderTextColor, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!])
        self.attributedPlaceholder = placeholderFirstName
    }
}

/*
extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType? {
        guard iPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }
}
*/


public extension UIDevice {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case Unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208, 1920:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        default:
            return .Unknown
        }
    }
    
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            return false
        case .online(.wwan):
            print("Connected via WWAN")
            return true
        case .online(.wiFi):
            print("Connected via WiFi")
            return true
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}

extension UIViewController {
    func addToolBar(textField: UISearchBar) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)

        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self as? UISearchBarDelegate
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        view.endEditing(true) // or do something
    }
}

// MARK:- extension UIImage

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}
public extension UIDevice {
    
    /// pares the deveice name as the standard name
    var modelName: String {
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }
    
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   == 1 { return "\(years(from: date)) year"   } else if years(from: date)   > 1 { return "\(years(from: date)) years"   }
        if months(from: date)  == 1 { return "\(months(from: date)) month"  } else if months(from: date)  > 1 { return "\(months(from: date)) month"  }
        if weeks(from: date)   == 1 { return "\(weeks(from: date)) week"   } else if weeks(from: date)   > 1 { return "\(weeks(from: date)) weeks"   }
        if days(from: date)    == 1 { return "\(days(from: date)) day"    } else if days(from: date)    > 1 { return "\(days(from: date)) days"    }
        if hours(from: date)   == 1 { return "\(hours(from: date)) hour"   } else if hours(from: date)   > 1 { return "\(hours(from: date)) hours"   }
        if minutes(from: date) == 1 { return "\(minutes(from: date)) minute" } else if minutes(from: date) > 1 { return "\(minutes(from: date)) minutes" }
        return ""
    }
}
