//
//  flowlayoutClass.m
//  MySportsCast
//
//  Created by Vardhan on 17/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "flowlayoutClass.h"

static NSString * const customCellKey = @"CustomCollectionViewCell";
@implementation flowlayoutClass

- (id)init
{
    self = [super init];
    if (self) {
        
        
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    
    
    appdelegate = [UIApplication sharedApplication].delegate;
    self.itemInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    self.itemSize = CGSizeMake(110,110);

//array = @[@"vardhanreddypola",@"pola",@"vardhan",@"kd",@"ashsih",@"kd1",@"swetha",@"praveen",@"manasa",@"umakanth",@"sandeep",@"lavanya1",@"lavanya2"];    self.selectedArray = [[NSArray alloc]init];
    
}


-(void)prepareLayout
{
    originX = 10;
    originY = 10;
    
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger row = 0; row < rowCount; row++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
        
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
        
        cellLayoutInfo[indexPath] = itemAttributes;
        
    }
    
    newLayoutInfo[customCellKey] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
    
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGRect rect;
    
    //    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    width = self.collectionView.frame.size.width;
    //    float layOutwidth = width/2-15;
   
    NSString * string  = [appdelegate.tagSelectedArray objectAtIndex:indexPath.row];
    CGSize calCulateSizze  = [string sizeWithAttributes:
                              @{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];;
    
    if (originX+ceilf(calCulateSizze.width)+5 < width)
    {
        rect = CGRectMake(originX, originY, ceilf(calCulateSizze.width)+10, ceilf(calCulateSizze.height)+10);
        originX = originX+ceilf(calCulateSizze.width)+12;
        
        
    }
    else
    {
        originX = 10;
        originY = originY+ceilf(calCulateSizze.height)+12;
        rect = CGRectMake(originX, originY, ceilf(calCulateSizze.width)+10, ceilf(calCulateSizze.height)+10);
        originX = originX+ceilf(calCulateSizze.width)+12;
    }
    
    
    
    return rect;
    
    
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[customCellKey][indexPath];
}


- (CGSize)collectionViewContentSize
{
    
    return CGSizeMake(self.collectionView.bounds.size.width, originY+100);
}
@end
