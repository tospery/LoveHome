//
//  JXLogFormatter.m
//  CocoaLumberjackTutorial
//
//  Created by 杨建祥 on 15/3/24.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableCocoaLumberjack
#import "JXLogFormatter.h"
#import "JXApple.h"

@implementation JXLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    return [NSString stringWithFormat:@"%@%@%@(%@)->%@",
            [logMessage.timestamp stringWithFormat:kJXFormatForDatetimeAll],
            [self levelString:logMessage.flag],
            logMessage.function,
            logMessage.threadID,
            logMessage.message];
}

- (NSString *)levelString:(DDLogFlag)level {
    NSString *result;
    switch (level) {
        case DDLogFlagError:
            result = @"【Error】";
            break;
        case DDLogFlagWarning:
            result = @"【Warning】";
            break;
        case DDLogFlagInfo:
            result = @"【Info】";
            break;
        case DDLogFlagDebug:
            result = @"【Debug】";
            break;
        case DDLogFlagVerbose:
            result = @"【Verbose】";
            break;
        default:
            break;
    }
    return result;
}
@end
#endif
