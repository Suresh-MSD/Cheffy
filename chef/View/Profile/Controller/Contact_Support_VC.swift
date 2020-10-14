
import UIKit
import MessageUI

class Contact_Support_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func CloseVC(_ sender: UIButton) {
          
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Click_Phone(_ sender: UIButton) {
          
        let phoneNumber: String = "tel://+880289285365"
        UIApplication.shared.openURL(URL(string: phoneNumber)!)
    }
    
    @IBAction func Click_Mail(_ sender: UIButton) {
          
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["mailitsupport@gmail.com"])
        mailVC.setSubject("")
        mailVC.setMessageBody("", isHTML: false)

        present(mailVC, animated: true, completion: nil)
        
    }
    
    @IBAction func Click_Web(_ sender: UIButton) {
          
        if let url = URL(string: "https://www.cheffy.com") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func Click_Facebook(_ sender: UIButton) {
          
        UIApplication.tryURL(urls: [
        "fb://profile/cheffy", // App
        "http://www.facebook.com/cheffy" // Website if app fails
        ])
    }
    

}

extension Contact_Support_VC : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
