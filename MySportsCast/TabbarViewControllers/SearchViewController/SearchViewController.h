//
//  SearchViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    
    UIButton *eventButton;
    UIButton * peopleButton;
    UIView * singleLineView;
}
@property (weak, nonatomic) IBOutlet UITextField *textFiledSearch;
- (IBAction)SearchButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewButtonBackGround;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIewSearchData;

@end
