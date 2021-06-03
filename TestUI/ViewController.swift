//
//  ViewController.swift
//  TestUI
//
//  Created by li on 2021/5/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func loadView() {
        
        view = UIView()
        
        view.backgroundColor = .red
    }
}
