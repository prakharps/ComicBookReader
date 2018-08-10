//
//  CollectionViewAdCell.h
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 10/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdsNativeSDK/AdsNativeSDK.h>

@interface CollectionViewAdCell : UICollectionViewCell <ANAdRendering>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsoredText;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *callToActionButton;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@end
