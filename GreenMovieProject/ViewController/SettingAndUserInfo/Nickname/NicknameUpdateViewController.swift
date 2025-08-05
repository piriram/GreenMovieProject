//
//  NicknameUpdateViewController.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/4/25.
//
import UIKit
import SnapKit
//TODO: NicknameCreateViewController와 NicknameUpdateViewController를 호환가능한 하나의 뷰로 만들 수 있을까? 그게 좋을까?
final class NicknameUpdateViewController: BaseViewController {
    
    let nicknameTextField = UITextField()
    let editButton = UIButton(type: .system)
    let completeButton = UIButton(type: .system)
    var nickname: String?
    let underline = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "닉네임 수정"
        
        configureUI()
        configureLayout()
        configureAction()
        configureNavigationBar()
    }
    
    func configureUI() {
        view.addSubview(nicknameTextField)
        view.addSubview(editButton)
        view.addSubview(completeButton)
        nicknameTextField.addSubview(underline)
        
        nicknameTextField.textColor = .white
        nicknameTextField.font = .systemFont(ofSize: 16)
        nicknameTextField.borderStyle = .none
        nicknameTextField.isUserInteractionEnabled = false
        
        editButton.setTitle("편집", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 15
        editButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        editButton.addTarget(self, action: #selector(goEditClicked), for: .touchUpInside)
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.primary, for: .normal)
        completeButton.layer.borderColor = UIColor.primary.cgColor
        completeButton.layer.borderWidth = 1
        completeButton.layer.cornerRadius = 24
        completeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        completeButton.addTarget(self, action: #selector(completButtonClicked), for: .touchUpInside)
        
        underline.backgroundColor = .lightGray
    }
    
    func configureLayout() {
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(editButton.snp.leading).offset(-8)
            make.height.equalTo(30)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTextField)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(52)
            make.height.equalTo(30)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        underline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureAction() {
        nicknameTextField.text = UserInfoManager.shared.readNickname() ?? ""
    }
    func configureNavigationBar() {
        let btn = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissClicked)
        )
        btn.tintColor = .primary
        navigationItem.leftBarButtonItem = btn
    }
    
    @objc func goEditClicked() {
        let detailVC = NicknameDetailViewController()
        detailVC.initialNickname = nicknameTextField.text
        detailVC.onNicknameClosure = { [weak self] updatedNickname in
            self?.nicknameTextField.text = updatedNickname
            
        }
        //        detailVC.configureStatusLabel()// 이떄 하면 텍스트가 빈값이라 원하는 작동이 안나옴
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func completButtonClicked() {
        
        guard let nicknameTextFieldText = nicknameTextField.text else { return }
        if nicknameTextFieldText.isEmpty {
            return
        }
        
        UserInfoManager.shared.createNickname(nicknameTextFieldText) // 가입일자는 건들이지않음
        NotificationHelper.post(NotificationHelper.updateNickname)
        dismiss(animated: true)
        
    }
    @objc func dismissClicked(){
        dismiss(animated: true)
    }
    
}
