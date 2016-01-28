//
//  RegistraionViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistraionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableviewRegistrtion;

- (IBAction)backButtonClicked:(id)sender;

@end
