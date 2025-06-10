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
        $0.register(HomeCoinTVCell.self, forCellReuseIdentifier: HomeCoinTVCell.id)
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    private let homeTitle: UILabel = {
        $0.text = "Home"
        $0.font = .poppins(weight: .semibold, size: 32)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    // MARK: - Dependencies
    
    private let interactor: HomeBusinessLogic
        
    private var viewModel: HomeModel?

    
    // MARK: - Initializers
    
    init(interactor: HomeBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
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
    
    //MARK: - User action
    
    @objc private func moreButtonTapped() {
        viewModel = nil
        updateSectionCoin()
        interactor.refresh()
    }
    
    private func updateSectionCoin() {
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
}

enum HomeViewSection: CaseIterable {
    case header, coins
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { HomeViewSection.allCases.count }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch HomeViewSection.allCases[section] {
        case .header:
            return 1
        case .coins:
            if let viewModel {
                return viewModel.coin.count
            } else {
                return 5
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeViewSection.allCases[indexPath.section] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeHeaderTVCell.id) as! HomeHeaderTVCell
            cell.headerAction = { [weak self] action in
                switch action {
                case .leartMore: print("Learn more")
                case .sort:
                    if let viewModel = self?.viewModel {
                        self?.interactor.sort(byAscending: viewModel.isAscending ? false : true )

                    }
                }
            }
            return cell

        case .coins:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeCoinTVCell.id) as! HomeCoinTVCell
            if let viewModel {
                let coin = viewModel.coin[indexPath.row]
                cell.congigure(coin: coin)
                return cell
            } else {
                cell.congigure(coin: nil)

                return cell
            }
        }
    }
}

extension HomeViewController: HomeDisplayLogic {
    func display(viewModel: HomeModel) {
        self.viewModel = viewModel
        updateSectionCoin()
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTVCell else { return }
        let offsetY = scrollView.contentOffset.y
        header.stretch(for: offsetY)
    }
}




struct HomeModel {
    struct Coin {
        let name: String
        let symbol: String
        let price: String
        let change: String
        let icon: UIImage
    }
    let coin: [Coin]
    let isAscending: Bool
}


protocol HomeBusinessLogic: AnyObject {
    func viewDidLoad()
    func refresh()
    func sort(byAscending: Bool)
}



final class HomeInteractor: HomeBusinessLogic {
    
    private let repo: CryptoRepository
    private let presenter: HomePresentationLogic
    private let symbols = [
        "btc","eth","tron","luna","polkadot",
        "dogecoin","tether","stellar","cardano","xrp"
    ]
    private var coins = [Coin]()
    private var ascending = true
    
    init(
        repo: CryptoRepository,
        presenter: HomePresentationLogic
    ) {
        self.repo = repo
        self.presenter = presenter
    }
    
    //MARK: - Public
    
    func viewDidLoad() {
        load()
    }
    
    func refresh(){
        coins.removeAll()
        load()
    }
    
    func sort(byAscending: Bool) {
        ascending = byAscending
        present(coins)
    }
    
    //MARK: - Private

    private func load() {
        repo.loadMetrics(for: symbols) { [weak self] result in
            switch result {
            case .success(let list):
                self?.coins = list
                self?.present(list)
                
            case .failure(_):
//                print(err)
                //TODO: - handle error
                break
            }
        }
    }
    
    private func present(_ list: [Coin]) {
        let sorted = list.sorted {
            ascending ? $0.change24h < $1.change24h
                      : $0.change24h > $1.change24h
        }
        presenter.present(coins: sorted, ascending: ascending)
    }
}

protocol HomePresentationLogic: AnyObject {
    func present(coins: [Coin], ascending: Bool)
}

final class HomePresenter: HomePresentationLogic {
    
    weak var view: HomeDisplayLogic?
    
    func present(coins: [Coin], ascending: Bool) {
        
        let coin = coins.map {
            HomeModel.Coin(
                name: $0.name,
                symbol: $0.symbol,
                price: $0.price.currencyFormat(),
                change: $0.change24h.percentFormat(),
                icon: $0.change24h >= 0 ? .up : .down
            )
        }
        view?.display(viewModel: .init(coin: coin, isAscending: ascending))
    }
}



protocol HomeDisplayLogic: AnyObject {
    func display(viewModel: HomeModel)
}

struct HomeViewControllerFactory {
    static func make() -> UIViewController {
        let network = NetworkLayer()
        let messaryRepo = MessariCryptoRepository(network: network)
        let presenter = HomePresenter()
        let interactor = HomeInteractor(repo: messaryRepo, presenter: presenter)
        let controller = HomeViewController(interactor: interactor)
        presenter.view = controller
        return controller
    }
}


#if DEBUG
#Preview {
    UINavigationController(rootViewController: HomeViewControllerFactory.make())
}
#endif
