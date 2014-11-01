#import "Component.h"

#import <BAFoundation/NSManagedObject+BAAdditions.h>

#import "Product.h"


@implementation Component

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"%@ (%@) - %zu devs, %zu features, %zu deps",
            self.name, self.product.name, [self.developers count], [self.features count], [self.dependencies count]];
}

- (NSString *)listString {
    return self.name;
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
	self.name = @"New Component";
}

@end
