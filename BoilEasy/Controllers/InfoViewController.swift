//
//  InfoViewController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 13.01.2024.
//

import UIKit
import SnapKit
import SafariServices


final class InfoViewController: UIViewController {
   //MARK: Properties
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "textLabel".localized()
        label.font = UIFont.SFUITextRegular(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "likeLabel".localized()
        label.font = UIFont.SFUITextRegular(ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("shareButton".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("rateButton".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let supportButton: UIButton = {
        let button = UIButton()
        button.setTitle("supportButton".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let letterButton: UIButton = {
        let button = UIButton()
        button.setTitle("letterButton".localized(), for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        addTarget()
    }
    
    private func setupConstraints() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
            make.height.equalToSuperview().priority(.low)
            make.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.greaterThanOrEqualTo(150)
        }
        
        contentView.addSubview(likeLabel)
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(likeLabel.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
//        contentView.addSubview(supportButton)
//        supportButton.snp.makeConstraints { make in
//            make.top.equalTo(rateButton.snp.bottom).offset(15)
//            make.leading.trailing.equalToSuperview().inset(15)
//            make.height.equalTo(40)
//        }
        
        contentView.addSubview(letterButton)
        letterButton.snp.makeConstraints { make in
            make.top.equalTo(rateButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-10)

        }

    }
    
    private func addTarget() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        supportButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
    }
    // share
    @objc private func shareButtonTapped() {
        let appURL = URL(string: "https://apps.apple.com/app/boileasy/id6470710176")!
        let shareText = "BoilEasy\n\(appURL)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        // Предотвратите показывание контроллера на iPad в поповере
        activityViewController.popoverPresentationController?.sourceView = view
        // Покажите UIActivityViewController
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func rateButtonTapped() {
        if let url = URL(string: "https://apps.apple.com/app/boileasy/id6470710176") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func buyButtonTapped() {
        if let url = URL(string: "https://www.buymeacoffee.com/shininswift") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func letterButtonTapped() {
        let recipient = "shininswift@gmail.com"
        let subject = "BoilEasy"
        
        let urlString = "mailto:\(recipient)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: urlString ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
