/********* alipay.m Cordova Plugin Implementation *******/
#import "Alipay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation Alipay

@synthesize appId, callbackId;

-(void)pluginInitialize
{
    self.appId = [[self.commandDelegate settings] objectForKey:@"alipayid"];
}

- (void)pay:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSString* orderString = [command.arguments objectAtIndex:0];

    if (!orderString) {
      /**  [self.commandDelegate sendPluginResult:[CDVPluginResult initWithStatus:CDVCommandStatus_ERROR message:orderString] 
            callbackId:self.callbackId];
        **/
          CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"pay not success"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

    NSString* appScheme = [NSString stringWithFormat:@"ali%@", self.appId];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        CDVPluginResult* pluginResult;
        
        if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic]; 
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
        
    }];
}

@end
