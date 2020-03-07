//
//  ViewController.swift
//  Example
//
//  Created by Gianpiero Spinelli on 06/03/2020.
//  Copyright © 2020 Gianpiero Spinelli. All rights reserved.
//

import UIKit
import Bauletto

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Show Bauletto", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showWifiError), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let settings = BaulettoSettings(icon: UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "It works", dismissMode: .automatic, hapticStyle: .notificationSuccess)
        Bauletto.show(withSettings: settings)
        
        let settings2 = BaulettoSettings(icon: UIImage(systemName: "hexagon", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "Blue tint color", tintColor: .blue, backgroundStyle: .dark, dismissMode: .custom(seconds: 2))
        Bauletto.show(withSettings: settings2)
    }
    
    // Simulates a wifi error banner.
    @objc func showWifiError() {
        // dismiss mode set as never, so we have to call the hide manually.
        let settings3 = BaulettoSettings(icon: UIImage(systemName: "wifi.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "Wifi lost", tintColor: .red, backgroundStyle: .systemChromeMaterial, dismissMode: .never)
        Bauletto.show(withSettings: settings3)
        
        // Hide the last banner after 10 seconds, since the dismissMode is `.never`.
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            Bauletto.hide()
        }
    }
}

