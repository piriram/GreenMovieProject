//
//  RecentSearchView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/1/25.
//

import UIKit
import SnapKit

final class RecentSearchView: UIView {
    
    var keywords: [String] = []
    
    let titleLabel = UILabel()
    
    var onKeywordClosure: ((String) -> Void)?
    let scrollView = UIScrollView()
    let keywordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        //        stackView.lineBreakMode = .byTruncatingTail
        stackView.clipsToBounds = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureUI()
        configureLayout()
        reloadKeywords()
    }
    func configureUI() {
        titleLabel.text = "최근 검색어"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        
        
    }
    func createClearAllButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadKeywords() {
        keywords = RecentSearchManager.shared.readKeywords()
        keywordStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for keyword in keywords {
            let chipView = createChip(for: keyword)
            keywordStackView.addArrangedSubview(chipView)
        }
    }
    /// 외부에서 호출하여 키워드를 새로 갱신하는 함수
    func updateKeywords(_ newKeywords: [String]) {
        self.keywords = newKeywords
        reloadKeywords()
    }
    
    func configureLayout() {
        addSubview(titleLabel)
        addSubview(scrollView)
        let clearAllButton = createClearAllButton()
        addSubview(clearAllButton)
        scrollView.addSubview(keywordStackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview()
        }
        clearAllButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalToSuperview().offset(-4)
            
            
        }
        clearAllButton.addTarget(self, action: #selector(clearAllButtonClicked), for: .touchUpInside)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview()
        }
        
        keywordStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    func createChip(for keyword: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        
        let label = UILabel()
        label.text = keyword
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        
        let deleteButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        deleteButton.setImage(UIImage(systemName: "xmark",withConfiguration: config), for: .normal)
        deleteButton.tintColor = .black
        deleteButton.addTarget(self, action: #selector(deleteKeywordClicked(_:)), for: .touchUpInside)
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        deleteButton.tag = keywords.firstIndex(of: keyword) ?? -1
        
        container.addSubview(label)
        container.addSubview(deleteButton)
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(label.snp.trailing).offset(4)
            //            $0.size.equalTo(12)
            $0.trailing.equalToSuperview().offset(-4)
                        $0.centerY.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chipTouched(_ :)))
        container.addGestureRecognizer(tap)
        container.tag = keywords.firstIndex(of: keyword) ?? -1
        return container
    }
    @objc func chipTouched(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return } // 딥다이빙
        let index = view.tag
       let keyword =  keywords[index]
        onKeywordClosure?(keyword)
    }
    
    @objc func deleteKeywordClicked(_ sender: UIButton) {
        let index = sender.tag
        let removed = keywords[index]
        RecentSearchManager.shared.deleteOneKeyword(removed)
        reloadKeywords()
    }
    @objc func clearAllButtonClicked() {
        RecentSearchManager.shared.deleteAllKeyword()
        keywords = []
        reloadKeywords()
    }
    
}



