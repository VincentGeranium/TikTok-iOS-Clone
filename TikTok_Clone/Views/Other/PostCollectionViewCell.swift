//
//  PostCollectionViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/01.
//

import AVFoundation
import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // The reason of the make init(frame: CGRect) gonna want override init with frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        /*
         clipsToBounds
         
         Discussion

         Setting this value to true causes subviews to be clipped to the bounds of the receiver.
         If set to false, subviews whose frames extend beyond the visible bounds of the receiver are not clipped.
         The default value is false.
         */
        clipsToBounds = true
        
        // added imageView in contentView
        contentView.addSubview(imageView)
        
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //c.f : layoutSubviews() function is action to what subview we want on the cell
        // in this PostCollectionViewCell we want subview on the cell is thumbnailImageView
        
        // imageView as well as asign the cell
        imageView.frame = contentView.bounds
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // nil out the image
        imageView.image = nil
    }
    
    
    // MARK:- func configure(with post: PostModel)
    /*
     ‼️ this function is very heavy function
     if i can extend the app save a thumbnail at the time be upload
     that's more ideal
     so this function can be exceptable solution
     */
    
    // configure function
    // this function configure with PostModel
    func configure(with post: PostModel) {
        // Get download URL
        StorageManager.shared.getDownloadURL(for: post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("got url : \(url)")
                    // Generate thumbnail
                    // c.f : Generate thumbnail is happen through AVFoundation
                    let asset = AVAsset(url: url)
                    
                    let generator = AVAssetImageGenerator(asset: asset)
                    
                    do {
                        // cgImage pull out first Image from the video
                        // c.f : CG mean Core Graphic
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        // generate actual thumbnail
                        self.imageView.image = UIImage(cgImage: cgImage)
                    } catch {
                        
                    }
                case .failure(let error):
                    print("failed to get download url : \(error)")
                    break
                }
            }
        }
    }
}
