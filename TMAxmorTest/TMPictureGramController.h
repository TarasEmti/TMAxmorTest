//
//  TMPictureGrammController.h
//  TMAxmorTest
//
//  Created by Тарас on 17.07.16.
//  Copyright © 2016 Тарас. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TMPictureGramController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UITextFieldDelegate>

{
    NSMutableArray* arrPictures;
}

@end
