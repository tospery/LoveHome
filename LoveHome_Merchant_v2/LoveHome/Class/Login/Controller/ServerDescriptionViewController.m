//
//  ServerDescriptionViewController.m
//  LoveHome
//
//  Created by MRH on 15/11/23.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "ServerDescriptionViewController.h"

@interface ServerDescriptionViewController ()<UITextFieldDelegate>

// iboutlet textFiled property
@property (weak, nonatomic) IBOutlet UITextField *descripLableOne;
@property (weak, nonatomic) IBOutlet UITextField *descripLableTwo;
@property (weak, nonatomic) IBOutlet UITextField *decripLableThreed;

@end

@implementation ServerDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商铺描述";
    _descripLableOne.textAlignment = NSTextAlignmentLeft;
    _descripLableTwo.textAlignment = NSTextAlignmentLeft;
    _decripLableThreed.textAlignment = NSTextAlignmentLeft;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChangeText:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)textfieldDidChangeText:(UITextField *)textFiled {
    

    NSMutableString *content = [[NSMutableString alloc] init];;
    if (!JudgeContainerCountIsNull(_descripLableOne.text)) {
        [content appendString:_descripLableOne.text];
    }
    if (!JudgeContainerCountIsNull(_descripLableTwo.text)) {

        [content appendFormat:@",%@",_descripLableTwo.text];
    }
    if (!JudgeContainerCountIsNull(_decripLableThreed.text)) {
         [content appendFormat:@",%@",_decripLableThreed.text];
    }

    if (_contentBlcok) {
        _contentBlcok(JudgeContainerCountIsNull(content) ? @"" : content);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
