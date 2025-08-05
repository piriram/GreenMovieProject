//
//  OnboardingViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/4/25.
//

import UIKit
import SnapKit
// 여기에는 Base뷰컨도 백그라운드 컬러 블랙도 없는데 왜 배경이 블랙으로 나오죠..?
final class OnboardingViewController: UIViewController {
    
    let splashImageView = UIImageView()
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLayout()
    }
    
    func configureUI() {
        view.addSubview(splashImageView)
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(startButton)
        
        splashImageView.image = UIImage(named: "splash")
        splashImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "GreenPedia"
        titleLabel.font = .systemFont(ofSize: 22)
        titleLabel.textColor = .white
        
        nameLabel.text = "김소람"
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = .white
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.backgroundColor = .clear
        startButton.setTitleColor(.primary, for: .normal)
        startButton.layer.cornerRadius = 24
        startButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        startButton.layer.borderColor = UIColor.primary.cgColor
        startButton.layer.borderWidth = 1
        startButton.layer.masksToBounds = true
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
    }
    
    func configureLayout() {
        splashImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.width.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(splashImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    @objc func startButtonClicked() { // clicked touched tapped 차이?
        let vc = NicknameCreateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

