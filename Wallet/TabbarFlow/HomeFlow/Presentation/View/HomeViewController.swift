//
//  HomeViewController.swift
//  Wallet
//
//  Created by Yuriy on 09.06.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - UI

    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .colorF7F7FA
        $0.contentInsetAdjustmentBehavior = .never
        $0.separatorStyle = .none
        $0.register(HomeHeaderTVCell.self, forCellReuseIdentifier: HomeHeaderTVCell.id)
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    private let homeTitle: UILabel = {
        $0.text = "Home"
        $0.font = .poppins(weight: .semibold, size: 32)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    // MARK: - Dependencies

    
    // MARK: - Initializers


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    // MARK: - Layout

    private func setupView() {
        view.addSubview(tableView)
        view.turnoffTAMIC()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .moreButton, style: .done, target: self, action: #selector(moreButtonTapped))
    }
    
    @objc private func moreButtonTapped() {
        
    }
}

enum HomeViewSection: CaseIterable {
    case header, coins
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { HomeViewSection.allCases.count }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch HomeViewSection.allCases[section] {
        case .header: return 1
        case .coins: return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeViewSection.allCases[indexPath.section] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeHeaderTVCell.id) as! HomeHeaderTVCell
            cell.headerAction = { [weak self] action in
                switch action {
                case .leartMore: print("Learn more")
                case .sort: print("Sort")
                }
            }
            return cell

        case .coins:
            return UITableViewCell()
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTVCell else { return }
        let offsetY = scrollView.contentOffset.y
        header.stretch(for: offsetY)
    }
}





#if DEBUG
#Preview {
    UINavigationController(rootViewController: HomeViewController())
}
#endif
