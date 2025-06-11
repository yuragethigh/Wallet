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
    
    
    private lazy var navbarModalCV: ModalMenuView = {
        $0.delegate = self
        $0.configure(items: NavbarMenuItem.allCases)
        return $0
    }(ModalMenuView())
    
    private lazy var sortModalCV: ModalMenuView = {
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.configure(items: SortMenuItem.allCases)
        return $0
    }(ModalMenuView())

        
    // MARK: - Dependencies
    
    private let interactor: HomeBusinessLogic
    weak var coordinator: HomeCoordinatorOutput?
    private var viewModel: HomeModel?
    
    // MARK: - Initializers
    
    init(interactor: HomeBusinessLogic) {
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
        view.addSubview(navbarModalCV)

        view.turnoffTAMIC()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            navbarModalCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            navbarModalCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),

        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .moreButton, style: .done, target: self, action: #selector(moreButtonTapped))
    }
    
    //MARK: - User action
    
    @objc private func moreButtonTapped() {
        navbarModalCV.isShow ? navbarModalCV.dismiss() : navbarModalCV.present()
    }
    
    private func presentSortModal(y: CGFloat) {
        view.addSubview(sortModalCV)
        NSLayoutConstraint.activate([
            sortModalCV.topAnchor.constraint(equalTo: view.topAnchor, constant: y),
            sortModalCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29)
        ])
        sortModalCV.present()
    }
    
    private func closeSortModal() {
        sortModalCV.dismiss()
        sortModalCV.removeFromSuperview()
    }
    
    private func headerCellDidTapSort(_ cell: UITableViewCell) {
        guard let ip = tableView.indexPath(for: cell) else { return }

        let cellRectInTable = tableView.rectForRow(at: ip)
        let cellRectOnView  = tableView.convert(cellRectInTable, to: view)

        let y = cellRectOnView.maxY
        closeSortModal()
        presentSortModal(y: y)
    }


    //MARK: - Private methods
    
    private func closeModals() {
        navbarModalCV.dismiss()
        closeSortModal()
    }
    
    private func updateSectionCoin() {
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
}

//MARK: - ModalMenuViewDelegate
extension HomeViewController: ModalMenuViewDelegate {
    func modalMenu(_ menu: ModalMenuView, didSelect item: ModalMenuItem) {
        switch item {
        case let main as NavbarMenuItem:
            switch main {
            case .reload: reload()
            case .logout: coordinator?.logout()
            }
        case let profile as SortMenuItem:
            switch profile {
            case .none:  interactor.sort(sortType: .none)
            case .up24:  interactor.sort(sortType: .up24)
            case .down24: interactor.sort(sortType: .down24)
            }
        default: break
        }
        closeModals()
    }

    func reload() {
        viewModel = nil
        updateSectionCoin()
        interactor.refresh()
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
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
                case .leartMore:
                    print("Learn more")
                case .sort:
                    self?.headerCellDidTapSort(cell)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch HomeViewSection.allCases[indexPath.section] {
        case .header: break
        case .coins: coordinator?.presentDetail()
        }
    }
}

//MARK: - HomeDisplayLogic Presenter -> VC
extension HomeViewController: HomeDisplayLogic {
    func display(viewModel: HomeModel) {
        self.viewModel = viewModel
        updateSectionCoin()
    }
}

//MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeModals()
        guard let header = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeHeaderTVCell else { return }
        let offsetY = scrollView.contentOffset.y
        header.stretch(for: offsetY)
    }
}



struct HomeViewControllerFactory {
    static func make(coordinator: HomeCoordinatorOutput? = nil) -> UIViewController {
        let network = NetworkLayer()
        let messaryRepo = MessariCryptoRepository(network: network)
        let presenter = HomePresenter()
        let interactor = HomeInteractor(repo: messaryRepo, presenter: presenter)
        let controller = HomeViewController(interactor: interactor)
        controller.coordinator = coordinator
        presenter.view = controller
        return controller
    }
}


#if DEBUG
#Preview {
    UINavigationController(rootViewController: HomeViewControllerFactory.make())
}
#endif
