//
//  ViewController.swift
//  Emoji
//
//  Created by 百变家装002 on 17/1/12.
//  Copyright © 2017年 百变家装002. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    let textField = UITextField(frame: CGRect(x: 10, y: 100, width: 300, height: 30))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.backgroundColor = UIColor.gray
        textField.delegate = self
        view.addSubview(textField)
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = string as NSString
        if str.textIsEmojiOrNot() == true {
           return false
        }else{
            print("+++++++++++\(str.transEmojiToUnicode())")
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

