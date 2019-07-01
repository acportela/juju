//
//  JujuInputFieldSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class JujuInputFieldSpec: QuickSpec {
    
    override func spec() {
        
        var sut: JujuInputField!
        
        describe("JujuInputField") {
            
            context("when showing on screen") {
                
                //case name
                //case age
                //case email
                //case password
                
                context("with name input kind") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 60)
                        sut = JujuInputField(frame: frame, inputKind: .name)
                        sut.outlineRecursively()
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldName", record: true))
                    }
                    
                }
                
            }
        }
    }
}