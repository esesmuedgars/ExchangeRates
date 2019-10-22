//
//  AppCoordinator.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

protocol Coordinator {
    func startCoordinatorFlow()
}

private extension Coordinator {
    func setWindowRoot(viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}

protocol CoordinatorFlowDelegate: AnyObject {
    func presentCurrencyViewController(comparedCurrencies currencies: [CurrencyPair])
    func pushCurrencyViewController(selectedCurrencyAt index: Int, comparedCurrencies currencies: [CurrencyPair])
    func dismissPresentedViewController()
}

final class AppCoordinator: Coordinator, CoordinatorFlowDelegate {

    private var navigationController: UINavigationController!
    private let storyboard = UIStoryboard(name: "Main", bundle: .main)

    func startCoordinatorFlow() {
        setRootLandingViewController()
    }

    private func setRootLandingViewController() {
        let viewController = storyboard.instantiateViewController(ofType: LandingViewController.self)

        let viewModel = LandingViewModel()
        viewModel.delegate = viewController
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel

        navigationController = UINavigationController(rootViewController: viewController)
        setWindowRoot(viewController: navigationController)
    }

    func presentCurrencyViewController(comparedCurrencies currencies: [CurrencyPair]) {
        let viewController = storyboard.instantiateViewController(ofType: CurrencyViewController.self)

        let viewModel = CurrencyViewModel(comparedCurrencies: currencies)
        viewModel.delegate = viewController
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel

        let embeddedViewController = UINavigationController(rootViewController: viewController)
        embeddedViewController.modalPresentationStyle = .fullScreen

        navigationController.present(embeddedViewController,
                                     animated: true)
    }

    func pushCurrencyViewController(selectedCurrencyAt index: Int, comparedCurrencies currencies: [CurrencyPair]) {
        let viewController = storyboard.instantiateViewController(ofType: CurrencyViewController.self)

        let viewModel = CurrencyViewModel(selectedCurrencyAt: index,
                                          comparedCurrencies: currencies,
                                          canPushViewControllers: false)
        viewModel.delegate = viewController
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel

        guard let navigationController = self.navigationController.presentedViewController as? UINavigationController else {
            return
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    func dismissPresentedViewController() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
}
