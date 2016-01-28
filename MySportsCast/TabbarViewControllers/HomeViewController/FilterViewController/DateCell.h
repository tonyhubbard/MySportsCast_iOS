//
//  DateCell.h
//  MySportsCast
//
//  Created by Vardhan on 30/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCell : UITableViewCell

{
    NSMutableDictionary * filterDic;
    NSString *currentDate;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonDateselectAll;
@property (weak, nonatomic) IBOutlet UIButton *buttonFromDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonToDate;

@end
