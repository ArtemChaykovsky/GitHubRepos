//
//  UIImageView.swift
//  GitHubRepos
//
//  Created by Artem Chaykovsky on 20.10.2023.
//

import UIKit

extension UIImageView {
    
    func load(from urlString: String?, defaultImage: UIImage? = nil, isTemplate: Bool = false, completion: (() -> Void)? = nil) {
        if let def = defaultImage {
            self.image = def
        }
        guard let urlStr = urlString, let url = urlStr.encodedURL else { return }
        load(from: url, defaultImage: defaultImage, isTemplate: isTemplate, completion: completion)
    }
    
    func load(from imageURL: String, defaultImage: UIImage? = nil, completion: (() -> Void)? = nil) {
        if let def = defaultImage {
            self.image = def
        }
        guard let url = imageURL.encodedURL else { return }
        load(from: url, defaultImage: defaultImage, completion: completion)
    }
    
    func load(from imageURL: URL?, defaultImage: UIImage? = nil, isTemplate: Bool = false, completion: (() -> Void)? = nil) {
        if let def = defaultImage {
            self.image = def
        }
        guard let url = imageURL else {
            return
        }
        
        self.restorationIdentifier = url.absoluteString // save url and recheck it on complete to prevent flickering on multitple concurrent requests
        
        ImageCachingService.shared.load(from: url) { [weak self] image, fromCache in
            DispatchQueue.main.async { [weak self] in
                if let restorationIdentifier = self?.restorationIdentifier,
                   restorationIdentifier != url.absoluteString { // other request started, ignore this image
                    completion?()
                    return
                }
                // adding some animation for smooth load
                if let weakself = self, var img = image, !fromCache {
                    
                    // for changing tint in icons
                    if isTemplate { img = img.withRenderingMode(.alwaysTemplate) }
                    
                    UIView.transition(with: weakself,
                                      duration: 0.2,
                                      options: .transitionCrossDissolve,
                                      animations: { weakself.image = img })
                } else {
                    self?.image = isTemplate ? image?.withRenderingMode(.alwaysTemplate) : image
                }
                completion?()
            }
        }
    }
}

extension URL {
    
    var encodedURL: URL? {
        let urlComponents = URLComponents(string: self.absoluteString)
        return urlComponents?.url
    }
}

extension String {
    
    var encodedURL: URL? {
        let urlComponents = URLComponents(string: self)
        return urlComponents?.url
    }
    
}
