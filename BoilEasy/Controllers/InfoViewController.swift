//
//  InfoViewController.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 25.09.2023.
//

import Foundation
import UIKit
import SnapKit

final class InfoViewController: UIViewController {
    private let contentView = UIView()
    private let subtractImageView = UIImageView(image: UIImage(named: "subtract"))
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background.png")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        return view
    }()
    private let infoTitle: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "text"
        infoLabel.font = UIFont.SFUITextHeavy(ofSize: 20)
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        return infoLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    private func setupConstraints() {
        // background image view
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // gray background line
        view.addSubview(backgroundView)
        backgroundView.layer.zPosition = 100
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(50)
        }
        // substract
        backgroundView.addSubview(subtractImageView)
        subtractImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).offset(-24)
        }
        // scroll view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        // content view
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.height.equalTo(1700)
        }
        // info title
        view.addSubview(infoTitle)
        infoTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
        }
//        contentView.addSubview(infoTitle)
//        infoTitle.snp.makeConstraints { make in
//            make.centerX.equalTo(contentView)
//            make.top.equalTo(contentView).offset(70)
//        }
    }

    

} // end
