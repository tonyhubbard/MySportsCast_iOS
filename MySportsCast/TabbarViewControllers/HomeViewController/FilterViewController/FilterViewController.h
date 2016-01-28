//
//  FilterViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UITableView * tableViewFilter;
   

}
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property BOOL isFromCalendarEvent;

- (IBAction)applyButtonAction:(id)sender;

- (IBAction)restButtonAction:(id)sender;
@end
