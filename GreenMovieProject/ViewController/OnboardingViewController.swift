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
    
    // 폰트사이즈를 비례해서 키우기도하고 거리도 하기
    func configureUI() {
        view.addSubview(splashImageView)
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(startButton)
        
        splashImageView.image = UIImage(named: "splash")
        splashImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "GreenPedia"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        
        nameLabel.text = "당신만의 영화 세상\nGreenPedia를 시작해보세요."
        nameLabel.font = .systemFont(ofSize: 17)
        nameLabel.textColor = .lightGray
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        
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
            make.width.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(splashImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    @objc func startButtonClicked() { // clicked touched tapped 차이?
        let vc = NicknameCreateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

