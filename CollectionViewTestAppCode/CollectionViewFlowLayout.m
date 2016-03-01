//
// Created by David Clark on 18/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "CollectionViewFlowLayout.h"
#import "UICollectionView+Helper.h"

@interface CollectionViewFlowLayout (Predicates)

@property(nonatomic, readonly) NSPredicate *cellsPredicate;
@property(nonatomic, readonly) NSPredicate *headersPredicate;

@end

@implementation CollectionViewFlowLayout (Predicates)

- (NSPredicate *)cellsPredicate {
	return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		UICollectionViewLayoutAttributes *attributes = evaluatedObject;
		return attributes &&attributes.representedElementCategory == UICollectionElementCategoryCell;
	}];
}

- (NSPredicate *)headersPredicate {
	return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		UICollectionViewLayoutAttributes *attributes = evaluatedObject;
		return attributes &&attributes.representedElementKind == UICollectionElementKindSectionHeader;
	}];
}

@end

@implementation CollectionViewFlowLayout {

}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSMutableArray *allAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

	// find the first section that is visible in the content area
	NSIndexPath *firstSectionIndexPath = [self getFirstSectionIndexPath:allAttributes];

	// get the headers for the first and second sectionsUICollectionViewLayoutAttributes *firstHeader;
	UICollectionViewLayoutAttributes *firstHeader = [self getHeader:allAttributes forIndexPath:firstSectionIndexPath];
	CGPoint nextHeaderOrigin = [self getOriginOfNextHeader:allAttributes forIndexPath:firstSectionIndexPath];

	// add the first header back if it is not there
	firstHeader = [self ensureHeaderExists:firstHeader forIndexPath:firstSectionIndexPath toAttributes:allAttributes];

	// set the first header position to the top of the content area, or just above the second header
	firstHeader.frame = [self getFrameFor:firstHeader keepingAbove:nextHeaderOrigin];

	return allAttributes;
}

- (UICollectionViewLayoutAttributes *)ensureHeaderExists:(UICollectionViewLayoutAttributes *)header forIndexPath:(NSIndexPath *)indexPath toAttributes:(NSMutableArray *)allAttributes {
	if(!header) {
		header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
		[allAttributes addObject:header];
	}
	return header;
}

- (UICollectionViewLayoutAttributes *)getHeader:(NSMutableArray *)allAttributes forIndexPath:(NSIndexPath *)indexPath {
	for(UICollectionViewLayoutAttributes *attributes in [allAttributes filteredArrayUsingPredicate:self.headersPredicate]) {
		if(attributes.indexPath.section == indexPath.section) {
			return attributes;
		}
	}
	return nil;
}

- (CGPoint)getOriginOfNextHeader:(NSMutableArray *)allAttributes forIndexPath:(NSIndexPath *)indexPath {
	for(UICollectionViewLayoutAttributes *attributes in [allAttributes filteredArrayUsingPredicate:self.headersPredicate]) {
		if(attributes.indexPath.section == indexPath.section+1) {
			return attributes.frame.origin;
		}
	}
	return CGPointZero;
}

- (NSIndexPath *)getFirstSectionIndexPath:(NSMutableArray *)allAttributes {
	for(UICollectionViewLayoutAttributes *attributes in [allAttributes filteredArrayUsingPredicate:self.cellsPredicate]) {
		if([self.collectionView willShow:attributes]) {
			return attributes.indexPath;
		}
	}
	return nil;
}

- (CGRect)getFrameFor:(UICollectionViewLayoutAttributes *)header keepingAbove:(CGPoint)followingOrigin {
	CGPoint contentOrigin = [self getOriginFor:header keepingAbove:followingOrigin];
	return (CGRect){
			.origin = contentOrigin,
			.size = header.frame.size
	};
}

- (CGPoint)getOriginFor:(UICollectionViewLayoutAttributes *)header keepingAbove:(CGPoint)followingOrigin {
	CGPoint contentOrigin = [self.collectionView contentOffset];
	contentOrigin.y = MIN(contentOrigin.y, followingOrigin.y - header.frame.size.height);
	return contentOrigin;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return YES;
}

@end
