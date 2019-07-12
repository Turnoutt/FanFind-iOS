//
//  Navigate.swift
//  FanFindDemo
//
//  Created by Christopher Woolum on 6/4/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation
import UIKit

protocol NavigateDelegate{
    func closeView()
}

class NavigateViewController: UIViewController, NavigateDelegate{
    @IBAction func appleTapped(_ sender: Any) {
        self.showToast(message: "Navigate using Apple Maps")
        //self.delegate?.closeView()
    }
    
    @IBAction func googleTapped(_ sender: Any) {
        self.showToast(message: "Navigate using Google Maps")
        //self.delegate?.closeView()
    }
    @IBAction func lyftTapped(_ sender: Any) {
        self.showToast(message: "Navigate using Lyft")
        //self.delegate?.closeView()
    }
    
    @IBAction func uberTapped(_ sender: Any) {
        self.showToast(message: "Navigate using Uber")
        //self.delegate?.closeView()
    }
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var closeBarButton: UIBarButtonItem!
    
    public var delegate: NavigateDelegate?
    
    @objc func closeView(){
        self.delegate?.closeView()
    }
    
    override func viewDidLoad() {
        self.title = "Navigate"
        self.closeBarButton.action = #selector(closeView)
    }
    
    @objc func closeButtonClicked(){
        print("clicked")
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
