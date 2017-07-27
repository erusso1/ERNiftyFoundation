//
//  Bundle+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 6/5/17.
//
//

extension Bundle {
    
    public func object<T>(forInfoPlistKey key: String) -> T? { return self.object(forInfoDictionaryKey: key) as? T }
}

public let UITermsOfUseURLKey = "UITermsOfUseURL"

public let UIPrivacyPolicyURLKey = "UIPrivacyPolicyURL"
