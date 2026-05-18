import UIKit

class TrackersViewController: UIViewController {
    
    private let addTrackerButton = UIButton()
    private let trackersMainLabel = UILabel()
    private let mockLabel = UILabel()
    private let mockImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    //MARK: - Setup Views
    
    private func setupViews() {
        setupTrackersMainLabel()
        setupAddTrackerButton()
        setupMockImage()
        setupMockLabel()
    }
        
    private func setupTrackersMainLabel() {
        trackersMainLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersMainLabel.text = "Трекеры"
        trackersMainLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(trackersMainLabel)
    }
    
    private func setupAddTrackerButton() {
        addTrackerButton.setImage(
            UIImage(resource: .plusButton),
            for: .normal
        )
        addTrackerButton.addTarget(
            self,
            action: #selector(plusTapped),
            for: .touchUpInside
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: addTrackerButton
        )
    }
    
    @objc
    private func plusTapped() {
        print("addTracker")
    }
    
    private func setupMockImage() {
        mockImage.translatesAutoresizingMaskIntoConstraints = false
        mockImage.image = UIImage(resource: .starForMiss)
        view.addSubview(mockImage)
    }
    
    private func setupMockLabel() {
        mockLabel.translatesAutoresizingMaskIntoConstraints = false
        mockLabel.text = "Что будем отслеживать?"
        mockLabel.font = .systemFont(ofSize: 12, weight: .medium)
        mockLabel.textAlignment = .center
        view.addSubview(mockLabel)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        trackersMainLabelConstraints()
        mockImageConstraints()
        mockLabelConstraints()
    }
    
    private func trackersMainLabelConstraints() {
        NSLayoutConstraint.activate([
            trackersMainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersMainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func mockImageConstraints() {
        NSLayoutConstraint.activate([
            mockImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mockImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func mockLabelConstraints() {
        NSLayoutConstraint.activate([
            mockLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mockLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mockLabel.topAnchor.constraint(equalTo: mockImage.bottomAnchor, constant: 8)
        ])
    }
}

