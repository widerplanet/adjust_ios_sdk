//
//  ADJWiderPlanet.h
//
//
//  Created by WiderPlanet on 12/21/17.
//
//

#import <Foundation/Foundation.h>

#import "ADJEvent.h"

@interface ADJWiderPlanetProduct : NSObject

@property (nonatomic, assign) float widerplanetPrice;

@property (nonatomic, assign) NSUInteger widerplanetQuantity;

@property (nonatomic, copy, nullable) NSString *widerplanetProductID;

- (nullable id)initWithId:(nullable NSString *)product_id price:(float)price quantity:(NSUInteger)quantity;

+ (nullable ADJWiderPlanetProduct *)productWithId:(nullable NSString *)product_id price:(float)price quantity:(NSUInteger)quantity;

@end

@interface ADJWiderPlanet : NSObject

+ (void)injectClientIdIntoWiderPlanetEvents:(nullable NSString *)client_id;

+ (void)injectCustomerIdIntoWiderPlanetEvents:(nullable NSString *)customerId;

+ (void)injectHashedUserIDIntoWiderPlanetEvents:(nullable NSString *)hashUserId;

+ (void)injectHashedEmailIntoWiderPlanetEvents:(nullable NSString *)hashEmail;

+ (void)injectDeeplinkIntoEvent:(nullable ADJEvent *)event url:(nullable NSURL *)url;

+ (void)injectCartIntoEvent:(nullable ADJEvent *)event products:(nullable NSArray *)products;

+ (void)injectUserLevelIntoEvent:(nullable ADJEvent *)event uiLevel:(NSUInteger)uiLevel;

+ (void)injectCustomEventIntoEvent:(nullable ADJEvent *)event uiData:(nullable NSString *)uiData;

+ (void)injectUserStatusIntoEvent:(nullable ADJEvent *)event uiStatus:(nullable NSString *)uiStatus;

+ (void)injectViewProductIntoEvent:(nullable ADJEvent *)event product_id:(nullable NSString *)product_id;

+ (void)injectViewListingIntoEvent:(nullable ADJEvent *)event product_ids:(nullable NSArray *)product_ids;

+ (void)injectAchievementUnlockedIntoEvent:(nullable ADJEvent *)event uiAchievement:(nullable NSString *)uiAchievement;

+ (void)injectViewSearchDatesIntoWiderPlanetEvents:(nullable NSString *)checkInDate checkOutDate:(nullable NSString *)checkOutDate;

+ (void)injectCustomEvent2IntoEvent:(nullable ADJEvent *)event uiData2:(nullable NSString *)uiData2 uiData3:(NSUInteger)uiData3;

+ (void)injectTransactionConfirmedIntoEvent:(nullable ADJEvent *)event
                                   products:(nullable NSArray *)products
                              transactionId:(nullable NSString *)transactionId
                                newCustomer:(nullable NSString *)newCustomer;

@end
