//
//  WeatherDiagramView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import Foundation
import UIKit

final class WeatherDiagramView: UIView {
    typealias Offset = CGPoint
    
    // MARK: - Properties
    
    var contentInset: UIEdgeInsets = .zero
    
    var gradientColors: [UIColor] = []
    var gradientColorLocations: [CGFloat] = []
    var gradientBorderColor: UIColor = .black
    var gradientBorderWidth: CGFloat = 1
    
    var pointColor: UIColor = .white
    var lineColor: UIColor = .black
    
    var lineWidth: CGFloat = 1
    var graphPointRadius: CGFloat = 2
    
    var xAxisColor: UIColor = .black
    var xAxisPointColor: UIColor = .black
    var xAxisWidth: CGFloat = 1
    
    var pointLabelFont: UIFont = .preferredFont(forTextStyle: .body)
    var pointLabelColor: UIColor = .black
    var pointLabelOffset: Offset = .zero
    
    var xAxisInfoLabelFont: UIFont = .preferredFont(forTextStyle: .body)
    var xAxisInfoLabelColor: UIColor = .black
    
    var xAxisPointLabelFont: UIFont = .preferredFont(forTextStyle: .body)
    var xAxisPointLabelColor: UIColor = .black
    var xAxisPointLabelSize: CGSize = .zero
    
    var data: [Int] = []
    var dataLabels: [String] = []
    var xAxisInfoImages: [UIImage] = []
    var xAxisInfoTexts: [String] = []
    var xAxisLabelTexts: [String] = []
    var bottomBorder: CGFloat = 0
    var xAxisYPosition:CGFloat = 0
    var xAxisInfoImagesOffset: Offset = .zero
    var xAxisInfoOffset: Offset = .zero
    var xAxisLabelOffset: Offset = .zero
    
    // MARK: - LifeCicle
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        
        guard let context = UIGraphicsGetCurrentContext(), !data.isEmpty else {
            return
        }
        
        // Calculate the x point
        let margin = contentInset.left + contentInset.right
        let leftBorder = contentInset.left
        let diagramWidth = width - margin
        let spacing = diagramWidth / CGFloat(self.data.count - 1)
        guard diagramWidth > 0 else { return }
        
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            return CGFloat(column) * spacing + leftBorder
        }
        
        // Calculate the y point
        let topBorder = contentInset.top + pointLabelFont.capHeight - pointLabelOffset.y
        
        let diagramHeight = bottomBorder - topBorder
        guard diagramHeight > 0 else { return }
        
        guard let maxValue = data.map({ $0.magnitude }).max() else {
            return
        }
        
        let columnYPoint = { (diagramPoint: Int) -> CGFloat in
            let yPoint = CGFloat(diagramPoint) / CGFloat(maxValue) * diagramHeight
            return diagramHeight + topBorder - yPoint // Flip the diagram
        }
        
        // Create array of Graph points
        let diagramPoints = data.enumerated().map { (i, value) in
            CGPoint(x: columnXPoint(i), y: columnYPoint(value))
        }
        
        guard let maxdiagramPoint = diagramPoints.max(by: { $0.y < $1.y }) else {
            return
        }
        
        let drawDiagramAndGradient = { [self] in
            let colors = gradientColors.map { $0.cgColor }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: gradientColorLocations
            ) else {
                return
            }
            
            // Draw the line diagram
            lineColor.setFill()
            lineColor.setStroke()
            
            let diagramPath = UIBezierPath()
            
            diagramPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(data[0])))
            
            for i in 1..<diagramPoints.count {
                diagramPath.addLine(to: diagramPoints[i])
            }
            
            // Create the clipping path for the diagram gradient
            context.saveGState()
            guard let clippingPath = diagramPath.copy() as? UIBezierPath else {
                return
            }
            
            clippingPath.addLine(to: CGPoint( x: columnXPoint(data.count - 1), y: maxdiagramPoint.y))
            clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: maxdiagramPoint.y))
            clippingPath.close()
            
            clippingPath.addClip()
            
            let semiHeight = bounds.height / 2.0
            let diagramStartPoint = CGPoint(x: contentInset.left, y: semiHeight)
            let diagramEndPoint = CGPoint(x: width - contentInset.right, y: semiHeight)
            
            context.drawLinearGradient(
                gradient,
                start: diagramStartPoint,
                end: diagramEndPoint,
                options: [])
            context.restoreGState()
            
            // Draw the line on top of the clipped gradient
            diagramPath.lineWidth = lineWidth
            diagramPath.stroke()
            
            // Draw the circles on top of the diagram stroke
            for i in 0..<data.count {
                var point = diagramPoints[i]
                point.x -= graphPointRadius
                point.y -= graphPointRadius
                
                let circle = UIBezierPath(
                    ovalIn: CGRect(
                        origin: point,
                        size: CGSize(
                            width: graphPointRadius * 2,
                            height: graphPointRadius * 2)
                    )
                )
                circle.fill()
            }
        }
        
        let drawDiagramDataLabels = { [self] in
            for i in 0..<data.count {
                let point = diagramPoints[i].offsetBy(dx: pointLabelOffset.x, dy: pointLabelOffset.y - pointLabelFont.capHeight)
                let string = NSAttributedString(string: dataLabels[i], attributes: [NSAttributedString.Key.font: pointLabelFont,
                                                                                    NSAttributedString.Key.foregroundColor: pointLabelColor])
                string.draw(at: point)
            }
        }
        
        let firstdiagramPoint = diagramPoints[0]
        let lastdiagramPoint = diagramPoints[diagramPoints.count - 1]
        
        let drawDiagramBorderLines = { [self] in
            // Draw horizontal diagram lines
            let linePath = UIBezierPath()
            let leftTopPoint = firstdiagramPoint.offsetBy(dx: -graphPointRadius, dy: graphPointRadius)
            let leftBottomPoint = CGPoint(x: leftTopPoint.x, y: maxdiagramPoint.y + graphPointRadius)
            let rightBottomPoint = CGPoint(x: lastdiagramPoint.x + graphPointRadius, y: maxdiagramPoint.y + graphPointRadius)
            let rightTopPoint = lastdiagramPoint.offsetBy(dx: graphPointRadius, dy: graphPointRadius)
            
            // Left line
            linePath.move(to: leftTopPoint)
            linePath.addLine(to: leftBottomPoint)
            
            // Bottom line
            linePath.addLine(to: rightBottomPoint)
            
            // Right line
            linePath.addLine(to: rightTopPoint)
            gradientBorderColor.setStroke()
            
            linePath.lineWidth = gradientBorderWidth
            
            let pattern: [CGFloat] = [3.0, 3.0]
            linePath.setLineDash(pattern, count: 2, phase: 0.0)
            linePath.stroke()
        }
        
        let drawAxisX = { [self] in
            // Draw X Axys line
            let linePath = UIBezierPath()
            
            linePath.move(to: CGPoint(x: firstdiagramPoint.x,
                                      y: xAxisYPosition))
            linePath.addLine(to: CGPoint(x: lastdiagramPoint.x,
                                         y: xAxisYPosition))
            
            self.xAxisColor.setStroke()
            
            linePath.lineWidth = xAxisWidth
            
            linePath.stroke()
            
            self.xAxisPointColor.setStroke()
            
            var point =  CGPoint(x: firstdiagramPoint.x,
                                 y: xAxisYPosition - xAxisPointLabelSize.height / 2)
            
            for diagramPoint in diagramPoints {
                point.x = diagramPoint.x
                
                let rect = UIBezierPath(
                    rect: CGRect(
                        origin: point,
                        size: xAxisPointLabelSize)
                )
                rect.fill()
            }
        }
        
        let drawAxisXLabels = { [self] in
            let point =  CGPoint(x: firstdiagramPoint.x + xAxisLabelOffset.x,
                                 y: xAxisYPosition + xAxisLabelOffset.y)
            
            drawTextRow(startPoint: point, texts: xAxisLabelTexts, font: xAxisPointLabelFont, color: xAxisPointLabelColor)
        }
        
        let drawAxisXInfoTexts = { [self] in
            let point =  CGPoint(x: firstdiagramPoint.x + xAxisInfoOffset.x,
                                 y: xAxisYPosition + xAxisInfoOffset.y)
            
            drawTextRow(startPoint: point, texts: xAxisInfoTexts, font: xAxisInfoLabelFont, color: xAxisInfoLabelColor)
        }
        
        func drawTextRow(startPoint: CGPoint, texts: [String], font: UIFont, color: UIColor) {
            var point = startPoint
            
            for (diagramPoint, text) in zip(diagramPoints, texts) {
                point.x = diagramPoint.x
                let attributes = [NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: color]
                let string = NSAttributedString(string: text, attributes: attributes)
                string.draw(at: point)
            }
        }
        
        let drawAxisXInfoImages = { [self] in
            var point =  CGPoint(x: firstdiagramPoint.x + xAxisInfoImagesOffset.x,
                                 y: xAxisYPosition + xAxisInfoImagesOffset.y)
            
            for (diagramPoint, image) in zip(diagramPoints, xAxisInfoImages) {
                point.x = diagramPoint.x
                let rect = CGRect(x: point.x, y: point.y, width: 30, height: 25)
                image.draw(in: rect)
            }
        }
        
        drawDiagramAndGradient()
        drawDiagramDataLabels()
        drawDiagramBorderLines()
        drawAxisX()
        drawAxisXLabels()
        drawAxisXInfoTexts()
        drawAxisXInfoImages()
    }
}

extension WeatherDiagramView {
    func setup(data: [Int],
               dataLabels: [String],
               xAxisInfoImages: [UIImage],
               xAxisInfoTexts: [String],
               xAxisLabelTexts: [String]
    ) {
        self.data = data
        self.dataLabels = dataLabels
        self.xAxisInfoImages = xAxisInfoImages
        self.xAxisInfoTexts = xAxisInfoTexts
        self.xAxisLabelTexts = xAxisLabelTexts
        
        self.setNeedsDisplay()
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
