import UIKit

class ReaderViewController: UIViewController {

    let bookTitle: String
    
    // Glassmorphism Bottom Bar
    let bottomBar = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    // UI Elements
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleLabel = UILabel()
    let contentTextLabel = UILabel()
    
    let backButton = UIButton(type: .system)
    let chapterPill = UIView()
    let chapterLabel = UILabel()
    let moreButton = UIButton(type: .system)
    
    init(title: String) {
        self.bookTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        
        // --- 1. Top Navigation ---
        backButton.setTitle("<", for: .normal)
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 18
        backButton.tintColor = .gray
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        view.addSubview(backButton)
        
        chapterPill.backgroundColor = .white
        chapterPill.layer.cornerRadius = 15
        chapterPill.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chapterPill)
        
        chapterLabel.text = "Chapter 24"
        chapterLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        chapterLabel.textColor = .darkGray
        chapterLabel.translatesAutoresizingMaskIntoConstraints = false
        chapterPill.addSubview(chapterLabel)
        
        moreButton.setTitle("•••", for: .normal)
        moreButton.backgroundColor = .white
        moreButton.layer.cornerRadius = 18
        moreButton.tintColor = .gray
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moreButton)
        
        // --- 2. Scrollable Text Content ---
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        titleLabel.text = bookTitle
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        contentTextLabel.text = """
        Tunde had walked the old railway tracks behind his grandmother's house his whole childhood, but he had never gone past Mile Seven. People in the village said the air changed there. Others said the birds refused to sing. His grandmother only said he should mind his business and stay near.
        
        One dry Saturday afternoon, curiosity finally pushed him forward. He followed the tracks past the familiar mango trees, past the broken storage shed, and past the spot where the rails curved slightly like a bent spine. When he reached the rusted Mile Seven marker, he stopped. The air felt still, almost like the world was holding its breath. A lantern sat in the middle of the tracks. It was lit, even though no one was around. The flame inside glowed blue. Not sky blue or river blue, but a strange soft blue that looked like it could hum if it wanted to.
        
        Tunde picked it up. The moment his fingers touched the metal handle, the ground under him trembled. Not the kind of tremble that makes you scared, but the type that feels like a greeting.
        """
        contentTextLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        contentTextLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
        contentTextLabel.numberOfLines = 0
        // Line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedString = NSMutableAttributedString(string: contentTextLabel.text!)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        contentTextLabel.attributedText = attributedString
        contentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentTextLabel)
        
        // --- 3. Glassmorphism Bottom Bar ---
        bottomBar.layer.cornerRadius = 35
        bottomBar.clipsToBounds = true
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        
        // Add fake icons to bottom bar
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.contentView.addSubview(stackView)
        
        let icons = ["📖", "💬", "🤍", "🪶"]
        for icon in icons {
            let btn = UIButton(type: .system)
            btn.setTitle(icon, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            stackView.addArrangedSubview(btn)
        }
        
        // --- Constraints ---
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            
            chapterPill.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            chapterPill.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chapterPill.heightAnchor.constraint(equalToConstant: 30),
            
            chapterLabel.centerXAnchor.constraint(equalTo: chapterPill.centerXAnchor),
            chapterLabel.centerYAnchor.constraint(equalTo: chapterPill.centerYAnchor),
            chapterLabel.leadingAnchor.constraint(equalTo: chapterPill.leadingAnchor, constant: 15),
            chapterLabel.trailingAnchor.constraint(equalTo: chapterPill.trailingAnchor, constant: -15),
            
            moreButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            moreButton.widthAnchor.constraint(equalToConstant: 36),
            moreButton.heightAnchor.constraint(equalToConstant: 36),
            
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150), // padding for bottom bar
            
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBar.widthAnchor.constraint(equalToConstant: 260),
            bottomBar.heightAnchor.constraint(equalToConstant: 70),
            
            stackView.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -30),
            stackView.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor)
        ])
    }
    
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
