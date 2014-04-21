#import "Component.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>

#import "Product.h"


@implementation Component

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"%@ (%@) - %u devs, %u features, %u deps",
            self.name, self.product.name, [self.developers count], [self.features count], [self.dependencies count]];
}

- (NSString *)listString {
    return self.name;
}

- (void)awakeFromInsert {
	self.name = @"New Component";
}

@end
