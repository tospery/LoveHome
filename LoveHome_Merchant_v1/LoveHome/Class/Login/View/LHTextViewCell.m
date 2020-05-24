//
//  LHTextViewCell.m
//  LoveHome-User-Clothes
//
//  Created by MRH-MAC on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHTextViewCell.h"

@implementation LHTextViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    _moenyTextFiled.delegate = self;
}

- (void)setTextModel:(TextCellModel *)textModel
{
    _textModel = textModel;
    _moenyTextFiled.userInteractionEnabled = _textModel.isInteractionEnabled;
    _moenyTextFiled.placeholder = _textModel.placeString;
    _moenyTextFiled.text = _textModel.contentString;
    _moenyTextFiled.keyboardType = _textModel.keybordType;
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
//    //NSLog(@"%@",_moenyTextFiled.text);
//    _textModel.contentString = _moenyTextFiled.text;
   
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _textModel.contentString = _moenyTextFiled.text;
}



@end
