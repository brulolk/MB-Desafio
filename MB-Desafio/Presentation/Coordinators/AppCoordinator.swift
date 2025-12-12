//
//  AppCoordinator.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private let window: UIWindow
    
    private let exchangeRepository: ExchangeRepositoryProtocol
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        // Configuração inicial da Nav Bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        self.navigationController.navigationBar.standardAppearance = appearance
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController.navigationBar.prefersLargeTitles = true
        
        self.exchangeRepository = ExchangeRepository()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Inicia o fluxo principal
        showList()
    }
    
    private func showList() {
        let useCase = GetExchangesUseCase(repository: exchangeRepository)
        let viewModel = ExchangeListViewModel(getExchangesUseCase: useCase)
        let viewController = ExchangeListViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
