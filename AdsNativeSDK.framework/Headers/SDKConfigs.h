//
//  SDKConfigs.h
//  AdsNative-iOS-SDK
//
//  Created by Arvind Bharadwaj on 28/09/15.
//  Copyright (c) 2015 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ANClientAdPositions;

extern const NSString *kDefaultPlayButtonImageURL;
extern const NSString *kDefaultCloseButtonImageURL;
extern const NSString *kDefaultExpandButtonImageURL;
extern const float kDefaultPercentVisibleForAutoplay;

@interface SDKConfigs : NSObject

@property ANClientAdPositions *positions;
@property Class renderingClass;
@property NSString *playButtonImageURL;
@property NSString *closeButtonImageURL;
@property NSString *expandButtonImageURL;
@property (nonatomic) float percentVisibleForAutoplay;

+ (instancetype)populateWithDefaults;
- (void)populateWithDefaultVideoAssets;
@end
