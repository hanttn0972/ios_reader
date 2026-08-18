import UIKit

class LibraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "HANBOOKS"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let openReaderButton = UIButton(type: .system)
        openReaderButton.setTitle("Continue Reading", for: .normal)
        openReaderButton.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        openReaderButton.setTitleColor(.white, for: .normal)
        openReaderButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        openReaderButton.layer.cornerRadius = 12
        openReaderButton.translatesAutoresizingMaskIntoConstraints = false
        openReaderButton.addTarget(self, action: #selector(openReader), for: .touchUpInside)
        view.addSubview(openReaderButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            openReaderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openReaderButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openReaderButton.widthAnchor.constraint(equalToConstant: 200),
            openReaderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func openReader() {
        let readerVC = ReaderViewController(title: "The Lantern At Mile Seventy-Six")
        navigationController?.pushViewController(readerVC, animated: true)
    }
}
