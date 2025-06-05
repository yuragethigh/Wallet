//
//  MainViewController.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import UIKit

final class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton()
        btn.addAction(for: .touchUpInside) { _ in
            print("back")
        }
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(.black, for: .normal)

        btn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 50),
            btn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


#if DEBUG
#Preview {
    MainViewController()
}
#endif
