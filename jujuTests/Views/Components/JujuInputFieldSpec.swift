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
            
            context("when presenting on screen") {
                
                context("a name input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 66)
                        sut = JujuInputField(frame: frame, inputKind: .name)
                        sut.setFeedback("feedback test")
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldName"))
                    }
                    
                }
                
                context("an age input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 66)
                        sut = JujuInputField(frame: frame, inputKind: .dateOfBirth)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldAge"))
                    }
                    
                }
                
                context("an email input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 66)
                        sut = JujuInputField(frame: frame, inputKind: .newEmail)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldEmail"))
                    }
                    
                }
                
                context("a password input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 66)
                        sut = JujuInputField(frame: frame, inputKind: .newPassword)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldPassword"))
                    }
                    
                }
            }
        }
    }
}
