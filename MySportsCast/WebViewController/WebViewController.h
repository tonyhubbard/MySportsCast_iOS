//
//  WebViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 15/12/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

- (IBAction)backButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
