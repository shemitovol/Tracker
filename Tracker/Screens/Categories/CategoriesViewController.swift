import UIKit

final class CategoriesViewController: UIViewController {

    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let addButton = UIButton()
    private let placeholderView = UIView()
    private let placeholderLabel = UILabel()
    private let placeholderImage = UIImageView()

    // MARK: - Public Properties
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    //MARK: - Private Properties
    private let viewModel: CategoriesViewModel

    //MARK: - Initialization
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .ypWhiteDay)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(placeholderView)
        setupTitleLabel()
        setupAddButton()
        setupTableView()
        setupPlaceholder()
        setupBindings()
        viewModel.load()
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Категория"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(resource: .ypBlackDay)
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Добавить категорию", for: .normal)
        addButton.setTitleColor(UIColor(resource: .ypWhiteDay), for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.backgroundColor = UIColor(resource: .ypBlackDay)
        addButton.layer.cornerRadius = 16

        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPlaceholder() {
        placeholderView.addSubview(placeholderImage)
        placeholderView.addSubview(placeholderLabel)

        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.text = "Привычки и события можно объединить по смыслу"
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.textColor = UIColor(resource: .ypBlackDay)
        placeholderLabel.textAlignment = .center

        placeholderImage.image = UIImage(resource: .starForMiss)

        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            placeholderImage.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),

            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor, constant: -16),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }

    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onEmptyStateChanged = { [weak self] isEmpty in
            self?.tableView.isHidden = isEmpty
            self?.placeholderView.isHidden = !isEmpty
        }
    }
    
    @objc private func addTapped() {
        let createVC = CreateCategoryViewController()

        createVC.onCreate = { [weak self] title in
            self?.viewModel.addCategory(title: title)
        }

        present(createVC, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? CategoryCell
        else {
            return UITableViewCell()
        }

        let category = viewModel.category(at: indexPath.row)
        let position: CellPosition
        let count = viewModel.numberOfRows()
        if count == 1 {
            position = .single
        } else if indexPath.row == 0 {
            position = .first
        } else if indexPath.row == count - 1 {
            position = .last
        } else {
            position = .middle
        }

        cell.configure(
            title: category.title,
            isSelected: category.title == viewModel.selectedTitle,
            position: position
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.selectCategory(at: indexPath.row)
        onCategorySelected?(category)
        dismiss(animated: true)
    }
}
