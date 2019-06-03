//
//  CustomFlowLayout.swift
//  Swipecolllection
//
//  Created by eHeuristic on 27/03/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import Foundation
import UIKit


class CustomFlowLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate
{
    private var draggedItemPath: IndexPath?
    private var initialItemCenter = CGPoint.zero
    weak var delegate: FlowLayout?

    let ITEM_SPACING = 0.0
    let EDGE_OFFSET = 0.0
    
    let minimumXPanDistanceToSwipe = 100.0
    let minimumYPanDistanceToSwipe = 200.0
    let StackMaximumSize = 3
    let CellOffset = 10
    let MaxItemY = 70
    let CellPadding = 0
    let minimumDistanceLikeUnlike = 35
    
    let ROTATION_STRENGTH:CGFloat = 100
    let ROTATION_ANGLE = CGFloat(Double.pi/8)
    
    func CViewWidth(_ v: Any) -> CGFloat {
        if #available(iOS 12.0, *) {
            return (v as AnyObject).frame.size.width
        } else {
             return 400
        }
        
    }
    func CViewHeight(_ v: Any)-> CGFloat {
        if #available(iOS 12.0, *) {
            return (v as AnyObject).frame.size.height
        } else {
            return 400
            
        }
    }
 
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func prepare() {
        super.prepare()
        
        if collectionView?.numberOfSections == 0 {
            return
        }
        // Add Pan Gesture to Collection view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        collectionView?.addGestureRecognizer(panGesture)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [AnyHashable] = []
        
        let numberOfItems: Int = collectionView?.numberOfItems(inSection: 0) ?? 0
        for itemIndex in 0..<numberOfItems {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let cellAttribs: UICollectionViewLayoutAttributes? = layoutAttributesForItem(at: indexPath)
            if let cellAttribs = cellAttribs {
                attributes.append(cellAttribs)
            }
        }
        
        return attributes as? [UICollectionViewLayoutAttributes]
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let numberOfItems: Int = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        var xPosition = CGFloat(CellPadding)
        var yPosition: CGFloat = 0.0
        
        if indexPath.row < Int(StackMaximumSize) && indexPath.row < numberOfItems - 1 {
            let maxYPosition = CGFloat(Int(CellOffset) * (Int(StackMaximumSize) - (indexPath.row + 1)))
            xPosition = CGFloat(Int(CellOffset) * (attributes.indexPath.row))
            yPosition = maxYPosition //MIN(yPosition, maxYPosition);
            attributes.isHidden = false
        } else {
            attributes.isHidden = numberOfItems > 1
        }
        
        let cWidth: CGFloat = CViewWidth(collectionView!) - xPosition * 2
        let cHeight: CGFloat = CViewHeight(collectionView!) - CGFloat(Int(CellOffset) * (Int(StackMaximumSize) - 1))
        
        attributes.zIndex = numberOfItems - indexPath.item
        
        attributes.frame = CGRect(x: xPosition, y: yPosition, width: cWidth, height: cHeight)
        
        return attributes
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        var result = true
        if (gestureRecognizer is UIPanGestureRecognizer) {
            let panGesture = gestureRecognizer as? UIPanGestureRecognizer
            let velocity: CGPoint? = panGesture?.velocity(in: collectionView)
            result = abs(Int(velocity?.y ?? 0)) < 250
        }
        return result
    }
    
    func findDraggingCell(byCoordinate coordinate: CGPoint) {
        let indexPath = IndexPath(item: 0, section: 0)
        
        //if indexPath
        //... Find cell for pan gesture tapped coordinate
        let cell: UICollectionViewCell? = collectionView?.cellForItem(at: indexPath)
        if cell != nil {
            draggedItemPath = indexPath
            initialItemCenter = cell?.center ?? CGPoint(x: 0, y: 0)
            
            if let cell = cell {
                collectionView?.bringSubviewToFront(cell)
            }
        }
    }
    
    func updateCenterPositionOfDraggingCell(_ coordinate: CGPoint) {
        
        if (draggedItemPath != nil) && draggedItemPath?.row == 0 && coordinate.y < 0 {
                if !(delegate?.shouldCellMoveUp(for: draggedItemPath))! {
                    return
                }
        
            let cell: UICollectionViewCell? = collectionView?.cellForItem(at: draggedItemPath ?? IndexPath(row: 0, section: 0))
            
            if cell != nil {
                
                
               // print("coordinate \(NSCoder.string(for: coordinate))")
                
                let newCenterX: CGFloat = initialItemCenter.x + coordinate.x
                let newCenterY: CGFloat = initialItemCenter.y + coordinate.y
    
                cell?.center = CGPoint(x: newCenterX, y: newCenterY)
                
                let rotationStrength: CGFloat = coordinate.x / CGFloat(ROTATION_STRENGTH)
                
                let rotationAngel = CGFloat(ROTATION_ANGLE * rotationStrength)
                print(rotationAngel)
                let transform = CGAffineTransform(rotationAngle: rotationAngel)
                
                cell?.transform = transform
                
                if Int(coordinate.x) > minimumDistanceLikeUnlike {
                   
                        delegate?.cellDidMovedRight(cell, indexPath: draggedItemPath ?? IndexPath(row: 0, section: 0))
                    
                } else if Int(coordinate.x) < -(minimumDistanceLikeUnlike) {

                        delegate?.cellDidMovedLeft(cell, indexPath: draggedItemPath)
                    
                } else {
                    
                        delegate?.cellDidNotMoved(cell, indexPath: draggedItemPath)
                }
            }
        }
    }
    
    func finishedDragging(_ cell: UICollectionViewCell?) {
        if (draggedItemPath != nil) {
            cell?.layer.borderColor = UIColor.clear.cgColor
            cell?.layer.borderWidth = 0.0
            
            let deltaX: CGFloat = (cell?.center.x ?? 0.0) - initialItemCenter.x
            let deltaY: CGFloat = (cell?.center.y ?? 0.0) - initialItemCenter.y
            var shouldSnapBack = true
            
            if (abs(Float(deltaX)) > Float(minimumXPanDistanceToSwipe)) {
                
                shouldSnapBack = false
            } else if (abs(Float(deltaY)) > Float(minimumYPanDistanceToSwipe)) {
                
                shouldSnapBack = false
            }
            
            if shouldSnapBack {
                UIView.setAnimationsEnabled(false)
                collectionView?.reloadItems(at: [draggedItemPath ?? IndexPath(row: 0, section: 0)])
                UIView.setAnimationsEnabled(true)
            } else {
               
                delegate?.cellDidMovedUp(cell, indexPath: draggedItemPath)
               
                initialItemCenter = CGPoint.zero
                draggedItemPath = nil
            }
        }
    }

    
    @objc func handlePan(_ sender: UIPanGestureRecognizer?) {
        switch sender?.state {
        case .began?:
            let initialPoint: CGPoint? = sender?.location(in: collectionView)
            findDraggingCell(byCoordinate: initialPoint ?? CGPoint(x: 0, y: 0))
        case .changed?:
            let newCenter: CGPoint? = sender?.translation(in: collectionView)
            updateCenterPositionOfDraggingCell(newCenter ?? CGPoint(x: 0.0, y: 0.0))
        default:
            
            // Release pan gesture
            if (draggedItemPath != nil) {
                finishedDragging(collectionView?.cellForItem(at: draggedItemPath ?? IndexPath(row: 0, section: 0)))
            }
        }
    }
    
}
