import UIKit
import WebKit

class ReaderViewController: UIViewController, WKNavigationDelegate {

    let bookTitle: String
    
    // Glassmorphism Bottom Bar
    let bottomBar = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    // UI Elements
    var webView: WKWebView!
    
    let topBar = UIVisualEffectView(effect: UIBlurEffect(style: .regular)) // optional, or just transparent
    let backButton = UIButton(type: .system)
    let chapterPill = UIView()
    let chapterLabel = UILabel()
    let moreButton = UIButton(type: .system)
    
    // JS for theming
    var isDarkMode = false
    var currentFontSize = 100 // percent
    
    init(title: String) {
        self.bookTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupUI()
        loadSampleChapter()
    }
    
    private func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        // Set background to transparent to allow parent view's color to show
        webView.backgroundColor = .clear
        webView.isOpaque = false
        // Add padding so text doesn't hide under the top/bottom bars
        webView.scrollView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 120, right: 0)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        
        // --- Web View Constraints ---
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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
        moreButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        view.addSubview(moreButton)
        
        // --- 2. Glassmorphism Bottom Bar ---
        bottomBar.layer.cornerRadius = 35
        bottomBar.clipsToBounds = true
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.contentView.addSubview(stackView)
        
        // Buttons
        let fontButton = UIButton(type: .system)
        fontButton.setTitle("aA", for: .normal)
        fontButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        fontButton.addTarget(self, action: #selector(didTapFont), for: .touchUpInside)
        
        let themeButton = UIButton(type: .system)
        themeButton.setTitle("🌙", for: .normal)
        themeButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        themeButton.addTarget(self, action: #selector(didTapTheme), for: .touchUpInside)
        
        stackView.addArrangedSubview(UIButton(type: .system)) // spacer
        stackView.addArrangedSubview(fontButton)
        stackView.addArrangedSubview(themeButton)
        stackView.addArrangedSubview(UIButton(type: .system)) // spacer
        
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
            
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBar.widthAnchor.constraint(equalToConstant: 260),
            bottomBar.heightAnchor.constraint(equalToConstant: 70),
            
            stackView.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor)
        ])
    }
    
    private func loadSampleChapter() {
        // Here we inject a base HTML structure simulating an EPUB chapter.
        // We use JS and CSS to allow dynamic changes without reloading.
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
            <style>
                :root {
                    --bg-color: transparent;
                    --text-color: #333333;
                    --font-size: 100%;
                }
                body {
                    background-color: var(--bg-color);
                    color: var(--text-color);
                    font-family: -apple-system, system-ui, sans-serif;
                    font-size: var(--font-size);
                    line-height: 1.6;
                    padding: 20px;
                    margin: 0;
                    transition: all 0.3s ease;
                }
                h1 {
                    font-size: 2em;
                    margin-bottom: 20px;
                }
            </style>
        </head>
        <body>
            <h1>\(bookTitle)</h1>
            <p>Tunde had walked the old railway tracks behind his grandmother's house his whole childhood, but he had never gone past Mile Seven. People in the village said the air changed there. Others said the birds refused to sing. His grandmother only said he should mind his business and stay near.</p>
            <p>One dry Saturday afternoon, curiosity finally pushed him forward. He followed the tracks past the familiar mango trees, past the broken storage shed, and past the spot where the rails curved slightly like a bent spine. When he reached the rusted Mile Seven marker, he stopped. The air felt still, almost like the world was holding its breath. A lantern sat in the middle of the tracks. It was lit, even though no one was around. The flame inside glowed blue.</p>
            <p>Tunde picked it up. The moment his fingers touched the metal handle, the ground under him trembled. Not the kind of tremble that makes you scared, but the type that feels like a greeting.</p>
            <p>...</p>
            <p>(The EPUB HTML chapter will be rendered here natively).</p>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSettings() {
        // Option menu
    }
    
    @objc func didTapFont() {
        currentFontSize += 15
        if currentFontSize > 150 { currentFontSize = 100 }
        
        let js = "document.documentElement.style.setProperty('--font-size', '\(currentFontSize)%');"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    @objc func didTapTheme() {
        isDarkMode.toggle()
        
        let textColor = isDarkMode ? "#E0E0E0" : "#333333"
        view.backgroundColor = isDarkMode ? UIColor(white: 0.1, alpha: 1.0) : UIColor(white: 0.94, alpha: 1.0)
        
        let js = "document.documentElement.style.setProperty('--text-color', '\(textColor)');"
        webView.evaluateJavaScript(js, completionHandler: nil)
        
        // Update pills styling
        let pillBg = isDarkMode ? UIColor(white: 0.2, alpha: 1.0) : .white
        let iconTint = isDarkMode ? UIColor.white : .gray
        
        backButton.backgroundColor = pillBg
        backButton.tintColor = iconTint
        
        chapterPill.backgroundColor = pillBg
        chapterLabel.textColor = iconTint
        
        moreButton.backgroundColor = pillBg
        moreButton.tintColor = iconTint
        
        bottomBar.effect = isDarkMode ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .regular)
    }
}
