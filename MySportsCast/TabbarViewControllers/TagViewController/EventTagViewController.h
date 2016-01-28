//
//  EventTagViewController.h
//  MySportsCast
//
//  Created by Vardhan on 23/09/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTagViewController : UIViewController <UITextFieldDelegate>
- (IBAction)backButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFiledSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewSearch;

@end
