//
//  SampleAdView.m
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 10/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

#import "SampleAdView.h"



//SampleAdView.m
@implementation SampleAdView


- (void)layoutAdAssets:(ANNativeAd *)adObject
{
    [adObject loadTitleIntoLabel:self.titleLabel];
    [adObject loadTextIntoLabel:self.mainTextLabel];
    [adObject loadCallToActionTextIntoButton:self.callToActionButton];
    [adObject loadIconIntoImageView:self.iconImageView];
    [adObject loadSponsoredTagIntoLabel:self.sponsoredText];
    [adObject loadImageIntoImageView:self.mainImageView];
    
    //Optional: Needs to be implemented for third party networks that require it.
    [adObject loadAdChoicesIconIntoView:self.adChoicesView];
    
    //Optional: Dictionary of custom fields as defined by the publisher
    NSDictionary *dictionary = [[adObject nativeAssets] objectForKey:kNativeCustomAssetsKey];
}

//Optional Method: To be used in case you want to change the height of a table or collection view
+ (CGSize)sizeWithMaximumWidth:(CGFloat)maximumWidth
{
    return CGSizeMake(maximumWidth, 150);
}

// Optional Method
// You MUST implement this method if SampleAdView uses a nib
+ (NSString *)nibForAd
{
    return @"SampleAddView";
}

@end
