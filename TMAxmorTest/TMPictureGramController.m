//
//  TMPictureGrammController.m
//  TMAxmorTest
//
//  Created by Тарас on 17.07.16.
//  Copyright © 2016 Тарас. All rights reserved.
//

#import "TMPictureGramController.h"
#import "TMPictureCell.h"
#import "TMCellData.h"

@interface TMPictureGramController ()

@property (strong, atomic) UIImagePickerController* imagePicker;

@end

@implementation TMPictureGramController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Creating an array with default data for CollectionView
    arrPictures = [NSMutableArray arrayWithCapacity:5];
    
    TMCellData* pic = [[TMCellData alloc] init];
    pic.cellName = @"Flowers";
    pic.cellPicture = [UIImage imageNamed:@"flowers.jpg"];
    [arrPictures addObject:pic];
    
    pic = [[TMCellData alloc] init];
    pic.cellName = @"Statue";
    pic.cellPicture = [UIImage imageNamed:@"statue.jpg"];
    [arrPictures addObject:pic];
    
    pic = [[TMCellData alloc] init];
    pic.cellName = @"Beach";
    pic.cellPicture = [UIImage imageNamed:@"beach.jpg"];
    [arrPictures addObject:pic];
    
    pic = [[TMCellData alloc] init];
    pic.cellName = @"Dog";
    pic.cellPicture = [UIImage imageNamed:@"dog.jpg"];
    [arrPictures addObject:pic];
    
    pic = [[TMCellData alloc] init];
    pic.cellName = @"Villa";
    pic.cellPicture = [UIImage imageNamed:@"villa.jpg"];
    [arrPictures addObject:pic];
    
    pic = [[TMCellData alloc] init];
    pic.cellName = @"Library";
    pic.cellPicture = [UIImage imageNamed:@"library.jpg"];
    [arrPictures addObject:pic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMPictureCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pgCell" forIndexPath:indexPath];
    TMCellData* item = arrPictures[indexPath.row];
    cell.cLabel.text = item.cellName;
    cell.img.image = item.cellPicture;
    cell.progView.progress = 0.0f;
    cell.progView.hidden = YES;
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TMPictureCell *busyCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    //Check if selected cell is in filter progress
    if (!busyCell.progView.hidden) {
        
        busyCell.isStoped = YES;
        busyCell.progView.hidden = YES;
        busyCell.progView.progress = 1.0f;
        
    } else {
    
        UIAlertController* subMenu = [UIAlertController alertControllerWithTitle:@"Choose Filter" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                                  
        UIAlertAction* actionDel = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [arrPictures removeObjectAtIndex:indexPath.row];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }];
    
        UIAlertAction* actionBW = [UIAlertAction actionWithTitle:@"Black & White" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self applyFilter:@"B&W" onCell:indexPath];
        }];
    
        UIAlertAction* actionInverse = [UIAlertAction actionWithTitle:@"Inverse" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self applyFilter:@"Inv" onCell:indexPath];
        }];
        
        UIAlertAction* actionMirror = [UIAlertAction actionWithTitle:@"Vertical mirror" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self applyFilter:@"Vmir" onCell:indexPath];
        }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [subMenu addAction:actionBW];
        [subMenu addAction:actionInverse];
        [subMenu addAction:actionMirror];
        [subMenu addAction:actionDel];
        [subMenu addAction:cancel];

        [self presentViewController:subMenu animated:YES completion:nil];
    }
}

- (IBAction)addCell:(id)sender {
    
    UIAlertController* subMenu = [UIAlertController alertControllerWithTitle:@"Select Source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* gallery = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleGallery];
    }];
    
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Camera roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleCamera];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [subMenu addAction:gallery];
    [subMenu addAction:camera];
    [subMenu addAction:cancel];
    
    [self presentViewController:subMenu animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    TMCellData* pic = [[TMCellData alloc] init];
    pic.cellPicture = chosenImage;
    
    NSString* name = [NSString stringWithFormat:@"Gallery pic %lu", (unsigned long)arrPictures.count];
    pic.cellName = name;
    
    [arrPictures addObject:pic];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:(arrPictures.count - 1) inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
    
}

#pragma mark MyFunctions

- (void)handleCamera {
    
    #if TARGET_IPHONE_SIMULATOR
    
    UIAlertController* error = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Camera is not available on simulator"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [error addAction:okButton];
    [self presentViewController:error animated:YES completion:nil];
    
    #elif TARGET_OS_IPHONE

    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
#endif
    
}

- (void)handleGallery {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)applyFilter:(NSString *)filterName onCell:(NSIndexPath *)indexPath {
    
    TMCellData* pic = [[TMCellData alloc] init];
    pic.cellPicture = [arrPictures[indexPath.row] cellPicture];
    pic.cellName = [arrPictures[indexPath.row] cellName];
    
    
    [arrPictures insertObject:pic atIndex:(indexPath.row + 1)];
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
    
    TMPictureCell *busyCell = [self.collectionView cellForItemAtIndexPath:newIndexPath];
    busyCell.loadState = [[UIView alloc] initWithFrame:busyCell.img.bounds];
    busyCell.loadState.backgroundColor = [UIColor blackColor];
    busyCell.loadState.alpha = 0.5f;
    [busyCell addSubview:busyCell.loadState];

    int delay = ((arc4random() % 24) + 8);
    float tic = 0.1f / delay;
    
    NSNumber *progressTic = [NSNumber numberWithFloat:tic];
    NSMutableDictionary* cellInfo = [NSMutableDictionary dictionaryWithObject:busyCell forKey:@"cell"];
    [cellInfo setObject:progressTic forKey:@"Tic"];
    
    NSTimer* timer = [[NSTimer alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayBeforeFilter:) userInfo:cellInfo repeats:YES];
    
    UIImage *originalImg = pic.cellPicture;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciimg = [CIImage imageWithCGImage:originalImg.CGImage];
    
    if ([filterName  isEqual:@"B&W"]) {
        
        CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
        [filter setValue:ciimg forKey:kCIInputImageKey];
        CIImage *result = [filter outputImage];
        CGImageRef cgimg = [context createCGImage:result fromRect:[result extent]];

        UIImage *resultImg = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        
        NSString *name = [NSString stringWithFormat:@"%@ B&W", pic.cellName];
        pic.cellName = name;
        pic.cellPicture = resultImg;
        
    } else if ([filterName isEqual:@"Inv"]) {
        
        CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
        [filter setValue:ciimg forKey:kCIInputImageKey];
        CIImage *result = [filter outputImage];
        CGImageRef cgimg = [context createCGImage:result fromRect:[result extent]];
        
        UIImage *resultImg = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);

        
        NSString *name = [NSString stringWithFormat:@"%@ Inv", pic.cellName];
        pic.cellName = name;
        pic.cellPicture = resultImg;
        
    } else if ([filterName isEqual:@"Vmir"]){
       
        UIImage *resultImg = [UIImage imageWithCGImage:originalImg.CGImage scale:1.0f orientation:UIImageOrientationDownMirrored];
        
        NSString *name = [NSString stringWithFormat:@"%@ Vmir", pic.cellName];
        pic.cellName = name;
        pic.cellPicture = resultImg;
    }
    arrPictures[newIndexPath.row] = pic;
}

- (void)delayBeforeFilter:(NSTimer *)timer {
    
    NSNumber *tic = [[timer userInfo] objectForKey:@"Tic"];
    TMPictureCell *busyCell = [[timer userInfo] objectForKey:@"cell"];
    
    if (busyCell.progView.progress < 1) {
        busyCell.progView.hidden = NO;
        busyCell.progView.progress += tic.floatValue;
    } else {
        [timer invalidate];
        busyCell.progView.hidden = YES;
        busyCell.progView.progress = 0.0f;
        busyCell.loadState.hidden = YES;
        NSIndexPath *index = [self.collectionView indexPathForCell:busyCell];
        if (!busyCell.isStoped) {
            [self.collectionView reloadItemsAtIndexPaths:@[index]];
        } else {
            [arrPictures removeObjectAtIndex:index.row];
            [self.collectionView deleteItemsAtIndexPaths:@[index]];
        }
    }

}

@end
