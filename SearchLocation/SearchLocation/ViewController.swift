//
//  ViewController.swift
//  SearchLocation
//
//  Created by Kazushi Uemura on 2019/10/05.
//  Copyright © 2019 Kazushi Uemura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "検索"
        button.setTitle("検索", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    @objc func buttonAction() {
        let storyboard = UIStoryboard(name: "MapViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        vc.text = textField.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

