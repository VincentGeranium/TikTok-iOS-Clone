//
//  SwitchTableViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/07.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    // the switch on and off position out to the controller the a delegate
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {

    static let identifire: String = "SwitchTableViewCell"

    weak var delegate: SwitchTableViewCellDelegate?

    // the subview is label and the switch
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let theSwitch: UISwitch = {
        let theSwitch: UISwitch = UISwitch()
        theSwitch.tintColor = .systemBlue
        theSwitch.isOn = UserDefaults.standard.bool(forKey: "save_video")
        return theSwitch
    }()

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        // this view is only present switch value. so, selectionStyle is none
        selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(theSwitch)

        theSwitch.addTarget(self, action: #selector(didChangeSwitchValue(_:)), for: .valueChanged)
    }

    @objc private func didChangeSwitchValue(_ sender: UISwitch) {
        // delegate
        // ready back to controller, load delegate is
        delegate?.switchTableViewCell(self, didUpdateSwitchTo: sender.isOn)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout and Prepare for reuse
    override func layoutSubviews() {
        super.layoutSubviews()

        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 0, width: label.width, height: contentView.height)

        theSwitch.sizeToFit()
        theSwitch.frame = CGRect(x: contentView.width - theSwitch.width - 10, y: 6, width: theSwitch.width, height: theSwitch.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    // configure the cell with viewModel
    // basically doing that all the other cell
    func configure(with viewModel: SwitchCellViewModel) {
        label.text = viewModel.title
        theSwitch.isOn = viewModel.isOn
    }
}
