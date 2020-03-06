//
//  ViewController.swift
//  Example
//
//  Created by Gianpiero Spinelli on 06/03/2020.
//  Copyright © 2020 Gianpiero Spinelli. All rights reserved.
//

import UIKit
import Banner

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Show Banner", for: .normal)
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
        
        let settings = BannerSettings(icon: UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "It works", dismissMode: .automatic, hapticStyle: .notificationSuccess)
        Banner.show(withSettings: settings)
        
        let settings2 = BannerSettings(icon: UIImage(systemName: "hexagon", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "Blue tint color", tintColor: .blue, backgroundStyle: .dark, dismissMode: .custom(seconds: 2))
        Banner.show(withSettings: settings2)
    }
    
    // Simulates a wifi error banner.
    @objc func showWifiError() {
        // dismiss mode set as never, so we have to call the hide manually.
        let settings3 = BannerSettings(icon: UIImage(systemName: "wifi.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "Wifi lost", tintColor: .red, backgroundStyle: .systemChromeMaterial, dismissMode: .never)
        Banner.show(withSettings: settings3)
        
        // Hide the last banner after 10 seconds.
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            Banner.hide()
        }
    }
}

