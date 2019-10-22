//
//  LandingViewController.swift
//  ExchangeRates
//
//  Created by @esesmuedgars
//

import UIKit

protocol LandingViewModelType: AnyObject {
    var title: String { get }
    var addCurrencyCellTitle: String { get }
    var addCurrencyButtonText: String { get }
    var addCurrencyDescriptionText: String { get }
    var deleteActionTitle: String { get }

    var numberOfItems: Int { get }

    func viewDidLoad()

    func exchangeRateItem(at indexPath: IndexPath) -> UIExchangeRate
    func removeExchangeRateItem(at indexPath: IndexPath, completionHandler complete: @escaping (Bool) -> Void)

    func presentCurrencyViewController()
}

class LandingViewController: UIViewController, LandingViewModelDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.register(cellOfType: AddCurrencyCell.self)
            tableView.register(cellOfType: ExchangeRateCell.self)
        }
    }
    @IBOutlet private var noDataView: UIView!
    @IBOutlet private var addImageButton: UIButton! {
        didSet {
            addImageButton.imageView?.contentMode = .scaleAspectFit
            addImageButton.contentHorizontalAlignment = .fill
            addImageButton.contentVerticalAlignment = .fill
        }
    }
    @IBOutlet private var addTextButton: UIButton!
    @IBOutlet private var descriptionLabel: UILabel!

    @IBAction func didTapAdd() {
        viewModel.presentCurrencyViewController()
    }

    var viewModel: LandingViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        bindUI()

        viewModel.viewDidLoad()
    }

    private func bindUI() {
        title = viewModel.title

        addTextButton.setTitle(viewModel.addCurrencyButtonText, for: .normal)
        descriptionLabel.text = viewModel.addCurrencyDescriptionText
    }

    private func adjustUI(withoutData: Bool) {
        noDataView.isHidden = !withoutData
        navigationController?.setNavigationBarHidden(withoutData, animated: false)
    }

    // MARK: - LandingViewModelDelegate

    func viewModelDidFetchPersisted() {
        adjustUI(withoutData: false)

        tableView.reloadData()
    }

    func viewModelDidFetch() {
        adjustUI(withoutData: false)

        tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .top)
    }

    func viewModelDidUpdate(rates: [UIExchangeRate]) {
        for (index, rate) in rates.enumerated() {
            let cell = tableView.cellForRow(at: IndexPath(row: index + 1, section: 0)) as? ExchangeRateCell
            cell?.update(toAmount: rate.toAmount)
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(AddCurrencyCell.self, for: indexPath)
            cell.configure(titleText: viewModel.addCurrencyCellTitle)

            return cell
        default:
            let cell = tableView.dequeueReusableCell(ExchangeRateCell.self, for: indexPath)

            let rate = viewModel.exchangeRateItem(at: indexPath)
            cell.configure(fromAmount: rate.fromAmount,
                           fromCurrency: rate.fromCurrency,
                           toAmount: rate.toAmount,
                           toCurrency: rate.toCurrency,
                           toCode: rate.toCode)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath != .zero
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        viewModel.presentCurrencyViewController()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: viewModel.deleteActionTitle) { [weak self] (_, _, complete) in
            self?.viewModel.removeExchangeRateItem(at: indexPath) { self?.adjustUI(withoutData: $0) }

            self?.tableView.deleteRows(at: [indexPath], with: .none)

            complete(true)
        }

        if #available(iOS 13.0, *) {
            delete.image = UIImage(systemName: "xmark")
        } else {
            delete.image = UIImage(named: "Xmark")
        }

        delete.backgroundColor = .revolutBlue

        return UISwipeActionsConfiguration(actions: [delete])
    }
}
