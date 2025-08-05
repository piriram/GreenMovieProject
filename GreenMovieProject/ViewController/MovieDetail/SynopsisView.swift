//
//  SynopsisView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//
import UIKit
import SnapKit
// MARK: @@애니메이션 넣어보기?
final class SynopsisView: UIView {
    
    let titleLabel = UILabel()
    let moreButton = UIButton(type: .system)
    let bodyLabel = UILabel()
    
    var isExpanded = false
    
    init(text: String) {
        super.init(frame: .zero)
        configureUI()
        bodyLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        titleLabel.text = "Synopsis"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        
        moreButton.setTitle("More", for: .normal)
        moreButton.setTitleColor(.primary, for: .normal)
        moreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        bodyLabel.font = .systemFont(ofSize: 15)
        bodyLabel.textColor = .white
        bodyLabel.numberOfLines = 3
        bodyLabel.lineBreakMode = .byTruncatingTail
        
        addSubview(titleLabel)
        addSubview(moreButton)
        addSubview(bodyLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func moreTapped() {
        isExpanded.toggle()
        bodyLabel.numberOfLines = isExpanded ? 0 : 3
        moreButton.setTitle(isExpanded ? "Hide" : "More", for: .normal)
        
    }
}
