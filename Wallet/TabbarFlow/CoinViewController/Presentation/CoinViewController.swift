//
//  CoinViewController.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

struct CoinViewControllerFactory {
    static func make(coordinator: CoinCoordinatorOutput? = nil, model: Coin) -> UIViewController {
        let presenter = CoinPresenter()
        let interactor = CoinInteractor(coin: model, presenter: presenter)
        let controller = CoinViewController(interactor: interactor)
        controller.coordinator = coordinator
        presenter.view = controller
        return controller
    }
}



final class CoinViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .colorF3F5F6
        $0.register(CoinInfoTVCell.self, forCellReuseIdentifier: CoinInfoTVCell.id)
        $0.register(SwitcherTVCell.self, forCellReuseIdentifier: SwitcherTVCell.id)
        $0.separatorStyle = .none
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    private let marketStatsView = MarketStatsView()
    
    // MARK: - Dependencies
    private var viewModel: ViewModel?
    weak var coordinator: CoinCoordinatorOutput?
    private let interactor: CoinBuisnessLogic

    // MARK: - Initializers
    
    init(interactor: CoinBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("Deinit - \(self)")
        #endif
        coordinator?.close()
    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(marketStatsView)
        view.turnoffTAMIC()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            marketStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            marketStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            marketStatsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            marketStatsView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.setSmallTitle(color: .color191C32, font: .poppins(weight: .medium, size: 14))
        navigationController?.setColor(backgroud: .colorF3F5F6, hideLine: true)
        navigationItem.title = viewModel?.coin.navtitle
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .back, style: .done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .moreButton, style: .done, target: self, action: #selector(logout))

    }

    
    //MARK: - User action
    
    @objc private func logout() {
        coordinator?.logoutFromDetail()
    }

    @objc private func close() {
        coordinator?.close()
    }

    
    //MARK: - Private methods

}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension CoinViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TabelViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel {
            switch TabelViewSection.allCases[indexPath.row] {
            case .info:
                let cell = tableView.dequeueReusableCell(withIdentifier: CoinInfoTVCell.id) as! CoinInfoTVCell
                cell.config(price: viewModel.coin.price, change: viewModel.coin.change, image: viewModel.coin.icon)
                return cell
            case .switcher:
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitcherTVCell.id) as! SwitcherTVCell
                cell.configure()
                cell.delegate = self
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
}

//MARK: - CoinDisplayLogic
extension CoinViewController: CoinDisplayLogic {
    func display(viewModel: ViewModel) {
        self.viewModel = viewModel
        marketStatsView.configure(with: [
            .init(title: "Market capitalization", value: viewModel.coin.cap),
            .init(title: "Circulating Suply", value: viewModel.coin.suply)
        ])
    }
}

//MARK: - SwitcherTVCellDelegate
extension CoinViewController: SwitcherTVCellDelegate {
    func didSelectTime(_ time: SwitcherTVCell.Time) {
        print(time)
    }
}



#if DEBUG
#Preview {
    UINavigationController(rootViewController: CoinViewControllerFactory.make(model: .init(id: "", name: "Bitcoin", symbol: "BTC", price: 11111111.23, change24h: 23)))
}
#endif
