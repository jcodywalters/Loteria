//
//  GameHome_VCViewController.swift
//  GSTest
//
//  Created by Cody on 2/14/17.
//  Copyright © 2017 Cody. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import QuartzCore
import PCLBlurEffectAlert


class GameHome_VCViewController: UIViewController {

    // Outlets and Actions
    
    @IBOutlet weak var lblFirstName: UILabel!
    
    @IBOutlet weak var imgPictureProfile: FBSDKProfilePictureView!
    
    @IBAction func btn_info(_ sender: Any) {
        let alertController = PCLBlurEffectAlert.Controller(title: "How are you doing?",
                                                           message: "Press a button!",
                                                           effect: UIBlurEffect(style: .dark),
                                                           style: .alert)
        let action1 = PCLBlurEffectAlert.AlertAction(title: "I’m fine.", style: .default) { _ in }
        let action2 = PCLBlurEffectAlert.AlertAction(title: "Not so good.", style: .default) { _ in }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.show()
    }
    
    
    // MAIN Method
    override func viewDidLoad() {
        super.viewDidLoad()

        if (firstName != "") {
            lblFirstName.text = firstName
        }
        
        self.imgPictureProfile.layer.masksToBounds = true
        self.imgPictureProfile.layer.cornerRadius = 8.0;
        let myColor : UIColor = UIColor.cyan
        self.imgPictureProfile.layer.borderColor = myColor.cgColor
        self.imgPictureProfile.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
