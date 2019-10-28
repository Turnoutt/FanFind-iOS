//
//  RequestLocationViewController.swift
//  FanFind
//
//  Created by Christopher Woolum on 10/21/19.
//

import Foundation

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
            
            let blurEffect = UIBlurEffect(style: .light)
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
            tabBarController.present(controller, animated: true)
        } else {
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
