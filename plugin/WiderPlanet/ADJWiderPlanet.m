//
//  ADJWiderPlanet.m
//
//
//  Created by WiderPlanet on 12/21/17.
//
//

#import "Adjust.h"
#import "ADJWiderPlanet.h"
#import "ADJAdjustFactory.h"

static const NSUInteger MAX_VIEW_LISTING_PRODUCTS = 10;

@implementation ADJWiderPlanetProduct

- (id)initWithId:(NSString *)product_id price:(float)price quantity:(NSUInteger)quantity {
    self = [super init];

    if (self == nil) {
        return nil;
    }

    self.widerplanetPrice = price;
    self.widerplanetQuantity = quantity;
    self.widerplanetProductID = product_id;

    return self;
}

+ (ADJWiderPlanetProduct *)productWithId:(NSString *)product_id price:(float)price quantity:(NSUInteger)quantity {
    return [[ADJWiderPlanetProduct alloc] initWithId:product_id price:price quantity:quantity];
}

@end

@implementation ADJWiderPlanet

static NSString * clientIDInternal;
static NSString * customerIDInternal;
static NSString * hashUserIDInternal;
static NSString * hashEmailInternal;
static NSString * userSegmentInternal;
static NSString * checkInDateInternal;
static NSString * checkOutDateInternal;

+ (id<ADJLogger>)logger {
    return ADJAdjustFactory.logger;
}

+ (void)injectViewSearchIntoEvent:(ADJEvent *)event checkInDate:(NSString *)din checkOutDate:(NSString *)dout {
    [event addPartnerParameter:@"din" value:din];
    [event addPartnerParameter:@"dout" value:dout];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectViewListingIntoEvent:(ADJEvent *)event product_ids:(NSArray *)product_ids {
    NSString *jsonProductsIds = [ADJWiderPlanet createWiderPlanetVLFromProducts:product_ids];
    [event addPartnerParameter:@"items" value:jsonProductsIds];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectViewProductIntoEvent:(ADJEvent *)event product_id:(NSString *)product_id {
    [event addPartnerParameter:@"items" value:product_id];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectCartIntoEvent:(ADJEvent *)event products:(NSArray *)products {
    NSString *jsonProducts = [ADJWiderPlanet createWiderPlanetVBFromProducts:products];
    [event addPartnerParameter:@"items" value:jsonProducts];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectTransactionConfirmedIntoEvent:(ADJEvent *)event
                                   products:(NSArray *)products
                              transactionId:(NSString *)transactionId
                                newCustomer:(NSString *)newCustomer {
    [event addPartnerParameter:@"order_id" value:transactionId];

    NSString *jsonProducts = [ADJWiderPlanet createWiderPlanetVBFromProducts:products];
    [event addPartnerParameter:@"items" value:jsonProducts];
    [event addPartnerParameter:@"new_customer" value:newCustomer];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectUserLevelIntoEvent:(ADJEvent *)event uiLevel:(NSUInteger)uiLevel {
    NSString *uiLevelString = [NSString stringWithFormat:@"%lu",(unsigned long)uiLevel];
    [event addPartnerParameter:@"ui_level" value:uiLevelString];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectUserStatusIntoEvent:(ADJEvent *)event uiStatus:(NSString *)uiStatus {
    [event addPartnerParameter:@"ui_status" value:uiStatus];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectAchievementUnlockedIntoEvent:(ADJEvent *)event uiAchievement:(NSString *)uiAchievement {
    [event addPartnerParameter:@"ui_achievmnt" value:uiAchievement];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectCustomEventIntoEvent:(ADJEvent *)event uiData:(NSString *)uiData {
    [event addPartnerParameter:@"ui_data" value:uiData];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectCustomEvent2IntoEvent:(ADJEvent *)event uiData2:(NSString *)uiData2 uiData3:(NSUInteger)uiData3 {
    [event addPartnerParameter:@"ui_data2" value:uiData2];

    NSString *uiData3String = [NSString stringWithFormat:@"%lu",(unsigned long)uiData3];
    [event addPartnerParameter:@"ui_data3" value:uiData3String];

    [ADJWiderPlanet injectOptionalParams:event];
}

+ (void)injectDeeplinkIntoEvent:(ADJEvent *)event url:(NSURL *)url {
    if (url == nil) {
        return;
    }

    [event addPartnerParameter:@"loc" value:[url absoluteString]];

    [ADJWiderPlanet injectOptionalParams:event];
}


+ (void)injectHashedUserIDIntoWiderPlanetEvents:(NSString *)hashUserId {
    hashUserIDInternal = hashUserId;
}


+ (void)injectHashedEmailIntoWiderPlanetEvents:(NSString *)hashEmail {
    hashEmailInternal = hashEmail;
}

+ (void)injectClientIdIntoWiderPlanetEvents:(NSString *)client_id {
    clientIDInternal = client_id;
}


+ (void)injectViewSearchDatesIntoWiderPlanetEvents:(NSString *)checkInDate checkOutDate:(NSString *)checkOutDate {
    checkInDateInternal = checkInDate;
    checkOutDateInternal = checkOutDate;
}

+ (void)injectUserSegmentIntoWiderPlanetEvents:(NSString *)userSegment {
    userSegmentInternal = userSegment;
}

+ (void)injectCustomerIdIntoWiderPlanetEvents:(NSString *)customerId {
    customerIDInternal = customerId;
}

+ (void)injectOptionalParams:(ADJEvent *)event {
    [ADJWiderPlanet injectClientId:event];
    [ADJWiderPlanet injectCustomerId:event];
    [ADJWiderPlanet injectHashedUserID:event];
    [ADJWiderPlanet injectHashedEmail:event];
    [ADJWiderPlanet injectSearchDates:event];
}


+ (void)injectClientId:(ADJEvent *)event {
    if (clientIDInternal == nil) {
        return;
    }
    
    [event addPartnerParameter:@"client_id" value:clientIDInternal];
}

+ (void)injectCustomerId:(ADJEvent *)event {
    if (customerIDInternal == nil) {
        return;
    }
    
    [event addPartnerParameter:@"customer_id" value:customerIDInternal];
}

+ (void)injectHashedUserID:(ADJEvent *)event {
    if (hashUserIDInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"hcuid" value:hashUserIDInternal];
}


+ (void)injectHashedEmail:(ADJEvent *)event {
    if (hashEmailInternal == nil) {
        return;
    }
    
    [event addPartnerParameter:@"hceid" value:hashEmailInternal];
}

+ (void)injectSearchDates:(ADJEvent *)event {
    if (checkInDateInternal == nil || checkOutDateInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"din" value:checkInDateInternal];
    [event addPartnerParameter:@"dout" value:checkOutDateInternal];
}


+ (NSString *)createWiderPlanetVBFromProducts:(NSArray *)products {
    if (products == nil) {
        [self.logger warn:@"WiderPlanet Event product list is nil. It will sent as empty."];
        products = @[];
    }

    NSUInteger productsCount = [products count];
    NSMutableString *widerplanetVBValue = [NSMutableString stringWithString:@"["];
    
    for (NSUInteger i = 0; i < productsCount;) {
        id productAtIndex = [products objectAtIndex:i];

        if (![productAtIndex isKindOfClass:[ADJWiderPlanetProduct class]]) {
            [self.logger error:@"WiderPlanet Event should contain a list of ADJWiderPlanetProduct"];
            return nil;
        }

        ADJWiderPlanetProduct *product = (ADJWiderPlanetProduct *)productAtIndex;
        NSString *productString = [NSString stringWithFormat:@"{\"event_item_id\":\"%@\",\"unit_price\":%f,\"quantity\":%lu}",
                                   [product widerplanetProductID],
                                   [product widerplanetPrice],
                                   (unsigned long)[product widerplanetQuantity]];

        [widerplanetVBValue appendString:productString];

        i++;

        if (i == productsCount) {
            break;
        }

        [widerplanetVBValue appendString:@","];
    }

    [widerplanetVBValue appendString:@"]"];

    return [widerplanetVBValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)createWiderPlanetVLFromProducts:(NSArray *)product_ids {
    if (product_ids == nil) {
        [self.logger warn:@"WiderPlanet View Listing product ids list is nil. It will sent as empty."];
        product_ids = @[];
    }

    NSUInteger productsIdCount = [product_ids count];

    if (productsIdCount > MAX_VIEW_LISTING_PRODUCTS) {
        [self.logger warn:@"WiderPlanet View Listing should only have at most 3 product ids. The rest will be discarded."];
    }

    NSMutableString *widerplanetVLValue = [NSMutableString stringWithString:@"["];

    for (NSUInteger i = 0; i < productsIdCount;) {
        id productAtIndex = [product_ids objectAtIndex:i];
        NSString *product_id;
        
        if ([productAtIndex isKindOfClass:[NSString class]]) {
            product_id = productAtIndex;
        } else if ([productAtIndex isKindOfClass:[ADJWiderPlanetProduct class]]) {
            ADJWiderPlanetProduct *widerplanetProduct = (ADJWiderPlanetProduct *)productAtIndex;
            product_id = [widerplanetProduct widerplanetProductID];
            
            [self.logger warn:@"WiderPlanet View Listing should contain a list of product ids, not of ADJWiderPlanetProduct. Reading the product id of the ADJWiderPlanetProduct."];
        } else {
            return nil;
        }

        NSString *product_idEscaped = [NSString stringWithFormat:@"\"%@\"", product_id];

        [widerplanetVLValue appendString:product_idEscaped];

        i++;

        if (i == productsIdCount || i >= MAX_VIEW_LISTING_PRODUCTS) {
            break;
        }

        [widerplanetVLValue appendString:@","];
    }

    [widerplanetVLValue appendString:@"]"];

    return [widerplanetVLValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
