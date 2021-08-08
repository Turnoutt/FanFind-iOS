//
//  RequestLocationViewController.swift
//  FanFind
//
//  Created by Christopher Woolum on 10/21/19.
//

import Foundation
import os.log

internal class RequestLocationViewController : UIViewController {
    @IBOutlet var mapHolder: UIView!
    @IBOutlet var notNowButton: UIButton!
    
    var action:(_ allowClicked: Bool, _ controller: UIViewController) -> Void
    
    public init(action:@escaping (_ allowClicked: Bool, _ controller: UIViewController) -> Void) {
        self.action = action
        
        super.init(nibName: "RequestLocationViewController", bundle: Bundle(for: RequestLocationViewController.self))
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notNowButton.tintColor = FanFindConfiguration.primaryColor
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            
            var blurEffect = UIBlurEffect(style: .light);
            
            if #available(iOS 13, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    blurEffect = UIBlurEffect(style: .dark)
                }
            }
            
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = view.frame
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.insertSubview(blurEffectView, at: 0)
        }
    }
    
    public static func show(on viewController: UIViewController, action:@escaping (_ allowClicked: Bool, _ controller: UIViewController) -> Void) {
        
        let controller = RequestLocationViewController(action: action)
        
        controller.modalPresentationStyle = .overCurrentContext;
        
        if let tabBarController = viewController.tabBarController {
            os_log("Parent is TabController", log: OSLog.ui, type: .debug)
            tabBarController.present(controller, animated: true)
        } else {
            os_log("Parent is ViewController", log: OSLog.ui, type: .debug)
            viewController.present(controller, animated: true)
        }
    }
    
    
    @IBAction func allowClicked(_ sender: Any) {
        self.action(true, self)
    }
    
    @IBAction func goBackClicked(_ sender: Any) {
        self.action(false, self)
    }
}
