//
//  Toast.swift
//  FanFind
//
//  Created by Christopher Woolum on 10/28/19.
//

import Foundation

public class Toast
{
    static func showAlert(window:UIWindow, backgroundColor:UIColor, textColor:UIColor, message:String)
    {
        
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "", size: 15)
        label.adjustsFontSizeToFitWidth = true
        
        label.backgroundColor =  backgroundColor //UIColor.whiteColor()
        label.textColor = textColor //TEXT COLOR
        
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: window.frame.size.width, y: 64, width: window.frame.size.width, height: 44)
        
        label.alpha = 1
        
        window.addSubview(label)
        
        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;
        
        UIView.animate(withDuration
            :2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                label.frame = basketTopFrame
        },  completion: {
            (value: Bool) in
            UIView.animate(withDuration:2.0, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                label.alpha = 0
            },  completion: {
                (value: Bool) in
                label.removeFromSuperview()
            })
        })
    }
    
    public static func showPositiveMessage(window:UIWindow,message:String)
    {
        showAlert(window: window, backgroundColor: UIColor.green, textColor: UIColor.white, message: message)
    }
    
    public static func showNegativeMessage(window: UIWindow,message:String)
    {
        showAlert(window: window, backgroundColor: UIColor.red, textColor: UIColor.white, message: message)
    }
}
