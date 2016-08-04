//
//  TMPictureCell.h
//  TMAxmorTest
//
//  Created by Тарас on 17.07.16.
//  Copyright © 2016 Тарас. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMPictureCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *cLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progView;
@property (strong, nonatomic) UIView *loadState;
@property (nonatomic) bool isStoped;

@end
