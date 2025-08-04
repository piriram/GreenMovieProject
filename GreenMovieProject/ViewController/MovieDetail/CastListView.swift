//
//  CastView.swift
//  GreenMovieProject
//
//  Created by piri kim on 8/3/25.
//
import UIKit
import SnapKit

final class CastListView: UIView {

    var cast: [Cast] = []
    let castListStackView = UIStackView()
    let titleLabel = UILabel()
    init(cast: [Cast]) {
        super.init(frame: .zero)
        self.cast = Array(cast.prefix(5)) // 5명까지만 보여줌
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        castListStackView.axis = .vertical
        castListStackView.spacing = 12
        castListStackView.alignment = .leading
        addSubview(castListStackView)
        addSubview(titleLabel)
        
        titleLabel.text = "Cast"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
       
        for member in cast {
            let itemView = CastCell(cast: member)
            castListStackView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }
    }

    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
            
        }
        castListStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
            
        }
    }
}
