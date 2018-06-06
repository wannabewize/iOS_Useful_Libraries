//
//  ViewController.swift
//  ColorChanging
//
//  Created by Jaehoon Lee on 2018. 6. 5..
//  Copyright © 2018년 Jaehoon Lee. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController, GCDAsyncSocketDelegate {
    
    var socket: GCDAsyncSocket!

    @IBAction func connectToServer(_ sender: Any) {
    }
    
    @IBAction func startColoring(_ sender: Any) {
        do {
            try socket.connect(toHost: "192.168.1.73", onPort: 3000)
            socket.readData(withTimeout: 10000, tag: 1)
        }
        catch let error {
            print("Error : \(error)")
        }
    }
    
    @IBAction func endColoring(_ sender: Any) {
        socket.disconnect()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        print("didReadPartialDataOfLength")
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        print("didConnectTo :", url)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let root = try? JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)),
            let color = root as? [String: Float],
            let blue = color["blue"], let green = color["green"], let red = color["red"] {

            print("red : \(red), green : \(green), blue : \(blue)")
            self.view.backgroundColor = UIColor.init(red: CGFloat(red/256), green: CGFloat(green/256), blue: CGFloat(blue/256), alpha: 1.0)
        }
        
        socket.readData(withTimeout: 10000, tag: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

