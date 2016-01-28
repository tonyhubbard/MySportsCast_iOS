//
//  WebViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 15/12/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"terms_and_conditions" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonAction:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
