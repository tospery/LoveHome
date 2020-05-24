//
//  JXViewModel.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol JXViewModelServices;

/// The type of the title view.
typedef NS_ENUM(NSUInteger, JXTitleViewType) {
    /// System title view
    JXTitleViewTypeDefault,
    /// Double title view
    JXTitleViewTypeDoubleTitle,
    /// Loading title view
    JXTitleViewTypeLoadingTitle
};

@interface JXViewModel : NSObject
/// Initialization method. This is the preferred way to create a new view model.
///
/// services - The service bus of the `Model` layer.
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithServices:(id<JXViewModelServices>)services params:(NSDictionary *)params;

/// The `services` parameter in `-initWithServices:params:` method.
@property (nonatomic, strong, readonly) id<JXViewModelServices> services;

/// The `params` parameter in `-initWithServices:params:` method.
@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic, assign) JXTitleViewType titleViewType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIColor *backgroundColor;

/// The callback block.
@property (nonatomic, copy) JXVoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

/// An additional method, in which you can initialize data, RACCommand etc.
///
/// This method will be execute after the execution of `-initWithServices:params:` method. But
/// the premise is that you need to inherit `JXViewModel`.
- (void)initialize;


@property (nonatomic, strong) User *user;

@end






