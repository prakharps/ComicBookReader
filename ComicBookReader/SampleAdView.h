//
//  SampleAdView.h
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 10/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdsNativeSDK/AdsNativeSDK.h>

@interface SampleAdView : UITableViewCell <ANAdRendering>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *callToActionButton;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *sponsoredText;

//Optional: Needs to be implemented for third party networks that require it.
@property (strong, nonatomic) IBOutlet UIView *adChoicesView;
@end
