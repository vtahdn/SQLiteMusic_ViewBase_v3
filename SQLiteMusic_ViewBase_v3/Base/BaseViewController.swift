//
//  BaseViewController.swift
//  SQLiteMusic_ViewBase_v3
//
//  Created by Viet Asc on 12/13/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var btn_Title = UIButton()
    var txt_Search = UITextField()
    
    @objc func chooseOrder() {
        
        print("Click")
        
    }
    
    // addBtn_Title()
    var titleButton = { (_ btn_Title: UIButton,_ viewController: BaseViewController) in
        
        btn_Title.setTitle("Linggka Team", for: .normal)
        btn_Title.setTitleColor(.gray, for: .highlighted)
        btn_Title.addTarget(self, action: #selector(chooseOrder), for: .touchUpInside)
        btn_Title.backgroundColor = .black
        viewController.view.addSubview(btn_Title)
        btn_Title.translatesAutoresizingMaskIntoConstraints = false
        viewController.constrain(btn_Title, viewController)
        
    }
    
    // addTxt_Search
    var searchTextField = { (_ txt_Search: UITextField, _ viewController: BaseViewController) in
        
        txt_Search.isHidden = true
        txt_Search.borderStyle = .roundedRect
        txt_Search.placeholder = "Enter name here"
        txt_Search.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(txt_Search)
        viewController.constrain(txt_Search, viewController)
        
    }
    
    var constrain = { (_ item: AnyObject,_ viewController: BaseViewController) in

        let cn1 = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1, constant: 0)
        let cn2 = NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1, constant: 0)
        let cn3 = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let cn4 = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1, constant: 88)
        NSLayoutConstraint.activate([cn1, cn2, cn3, cn4])
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // addBtn_Title()
        titleButton(btn_Title, self)
        
        // addText_Search()
        searchTextField(txt_Search, self)
        
    }
    
    @objc func checkHiddenSearch() {
        
        if txt_Search.isHidden {
            UIView.transition(with: self.txt_Search, duration: 0.5, options: .transitionCurlUp, animations: nil, completion: nil)
        } else {
            UIView.transition(with: self.txt_Search, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        txt_Search.isHidden = !txt_Search.isHidden
        txt_Search.resignFirstResponder()
        
    }
    
    var actionForRightBarButton = { (_ viewController: UIViewController) in
        viewController.tabBarController?.navigationItem.rightBarButtonItem?.target = viewController
        viewController.tabBarController?.navigationItem.rightBarButtonItem?.action = #selector(checkHiddenSearch)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setActionForRightBarButton()
        actionForRightBarButton(self)
        
    }

}
