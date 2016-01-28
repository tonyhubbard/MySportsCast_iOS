//
//  TagViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 16/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCell.h"
#import "CustomTableViewCell.h"
#import "flowlayoutClass.h"
// creating Custom delegate for data handling
@protocol TagsCustomDelegate <NSObject>

@required

-(void)TagsSelectedValues:(NSMutableArray *)selectedValues;
-(void)TagsSelectedId:(NSMutableArray *)selectedTagIds;

@end


@interface TagViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableViewTagSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewSelectedTag;
@property (weak, nonatomic) IBOutlet UITextField *textFiledSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelHeaderTitle;
@property (retain, nonatomic) NSMutableArray *selectedValues;
@property (retain, nonatomic) NSMutableArray *selecteTagIds;
@property (retain, nonatomic) NSMutableArray *tableViewDataArray;

@property (strong,nonatomic) NSString * headerName;

@property (nonatomic, weak) id<TagsCustomDelegate> delegate;
- (IBAction)doneButtonClicked:(id)sender;

- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewSelectedHight;


@end
