//
//  flowlayoutClass.h
//  MySportsCast
//
//  Created by Vardhan on 17/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface flowlayoutClass : UICollectionViewFlowLayout

{
    CGFloat originX;
    CGFloat originY;
    CGFloat width;
    CGFloat height;
    NSArray * array;
    AppDelegate * appdelegate ;
    
}

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSizes;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) NSDictionary * layoutInfo;
@property (strong,nonatomic) NSArray * selectedArray;
@end
