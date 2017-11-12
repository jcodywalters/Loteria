//
//  Login_VC.swift
//  GSTest
//
//  Created by Cody on 2/14/17.
//  Copyright © 2017 Cody. All rights reserved.
//

import UIKit
import GameSparks
import FBSDKLoginKit

var firstName = "test"
var pictureProfile = ""
var firstLoad = true


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var btnGameHome: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnGameHome.isHidden = true
        
        let loginButton = FBSDKLoginButton()
        
        let newCenter = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 70)
        loginButton.center = newCenter
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        if (FBSDKAccessToken.current()) != nil{
            btnGameHome.isHidden = false
            fetchProfile()
            //connectGSSDK()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (FBSDKAccessToken.current()) != nil && firstLoad{
            btnGameHome.isHidden = false
//            fetchProfile()
//            connectGSSDK()
            firstLoad = false
            performSegue(withIdentifier: "gameHome", sender: self)
        }
    }
    
    func loginButtonDidLogOut(_ btn: FBSDKLoginButton!) {
        FBSDKLoginManager().logOut()
        print("Did log out of facebook")
        btnGameHome.isHidden = true
        //enteredGameHome = false

    }
    
    func loginButton(_ btn: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
        fetchProfile()
        //connectGSSDK()
        btnGameHome.isHidden = false
        performSegue(withIdentifier: "gameHome", sender: self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchProfile() {
        print("fetching profile")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, email, picture.type(large)"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err)
                return
            }
            print(result)
            
            let result = result as? NSDictionary
            
            if let first_name = result?["first_name"] as? String {
                firstName = first_name
            }
        }
    }
    
    
    func connectGSSDK() {
        let gs = GS.init(apiKey: "n306478MKB7K", andApiSecret: "r4gfWTkLcThYBNJFV66E1sWy6kMJ7RD1", andCredential: "", andPreviewMode: true)
        
        gs?.setAvailabilityListener({ (available) in
            if (available) {
//                // Device Id
//                let dar = GSDeviceAuthenticationRequest.init()
//                
//                dar.setDeviceId("deviceId")
//                dar.setDeviceOS("IOS")
//                dar.setCallback({ (response) in
//                    
//                })
//                gs?.send(dar)
                
                // Facebook Id
                let req = GSFacebookConnectRequest.init()
                let fbAccessToken = FBSDKAccessToken.current().tokenString
                print(fbAccessToken)
                req.setAccessToken(fbAccessToken)
                req.setCode("code")
            
                gs?.send(req)
                
                
            }
        })
        
        gs?.connect()
    }
}

