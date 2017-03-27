/*
 * DO NOT EDIT.
 *
 * Generated by the protocol buffer compiler.
 * Source: unittest_swift_fieldorder.proto
 *
 */

//  Protos/unittest_swift_fieldorder.proto - test proto
// 
//  This source file is part of the Swift.org open source project
// 
//  Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
//  Licensed under Apache License v2.0 with Runtime Library Exception
// 
//  See http://swift.org/LICENSE.txt for license information
//  See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
// 
//  -----------------------------------------------------------------------------
// /
// / Check that fields get properly ordered when serializing
// /
//  -----------------------------------------------------------------------------

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _1: SwiftProtobuf.ProtobufAPIVersion_1 {}
  typealias Version = _1
}

fileprivate let _protobuf_package = "swift.protobuf"

struct Swift_Protobuf_TestFieldOrderings: SwiftProtobuf.Message, SwiftProtobuf.ExtensibleMessage, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TestFieldOrderings"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    11: .standard(proto: "my_string"),
    1: .standard(proto: "my_int"),
    101: .standard(proto: "my_float"),
    60: .standard(proto: "oneof_int64"),
    9: .standard(proto: "oneof_bool"),
    150: .standard(proto: "oneof_string"),
    10: .standard(proto: "oneof_int32"),
    200: .standard(proto: "optional_nested_message"),
  ]

  private class _StorageClass {
    var _myString: String? = nil
    var _myInt: Int64? = nil
    var _myFloat: Float? = nil
    var _options: Swift_Protobuf_TestFieldOrderings.OneOf_Options?
    var _optionalNestedMessage: Swift_Protobuf_TestFieldOrderings.NestedMessage? = nil

    init() {}

    init(copying source: _StorageClass) {
      _myString = source._myString
      _myInt = source._myInt
      _myFloat = source._myFloat
      _options = source._options
      _optionalNestedMessage = source._optionalNestedMessage
    }
  }

  private var _storage = _StorageClass()

  private mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  var myString: String {
    get {return _storage._myString ?? ""}
    set {_uniqueStorage()._myString = newValue}
  }
  var hasMyString: Bool {
    return _storage._myString != nil
  }
  mutating func clearMyString() {
    return _storage._myString = nil
  }

  var myInt: Int64 {
    get {return _storage._myInt ?? 0}
    set {_uniqueStorage()._myInt = newValue}
  }
  var hasMyInt: Bool {
    return _storage._myInt != nil
  }
  mutating func clearMyInt() {
    return _storage._myInt = nil
  }

  var myFloat: Float {
    get {return _storage._myFloat ?? 0}
    set {_uniqueStorage()._myFloat = newValue}
  }
  var hasMyFloat: Bool {
    return _storage._myFloat != nil
  }
  mutating func clearMyFloat() {
    return _storage._myFloat = nil
  }

  var oneofInt64: Int64 {
    get {
      if case .oneofInt64(let v)? = _storage._options {
        return v
      }
      return 0
    }
    set {
      _uniqueStorage()._options = .oneofInt64(newValue)
    }
  }

  var oneofBool: Bool {
    get {
      if case .oneofBool(let v)? = _storage._options {
        return v
      }
      return false
    }
    set {
      _uniqueStorage()._options = .oneofBool(newValue)
    }
  }

  var oneofString: String {
    get {
      if case .oneofString(let v)? = _storage._options {
        return v
      }
      return ""
    }
    set {
      _uniqueStorage()._options = .oneofString(newValue)
    }
  }

  var oneofInt32: Int32 {
    get {
      if case .oneofInt32(let v)? = _storage._options {
        return v
      }
      return 0
    }
    set {
      _uniqueStorage()._options = .oneofInt32(newValue)
    }
  }

  var optionalNestedMessage: Swift_Protobuf_TestFieldOrderings.NestedMessage {
    get {return _storage._optionalNestedMessage ?? Swift_Protobuf_TestFieldOrderings.NestedMessage()}
    set {_uniqueStorage()._optionalNestedMessage = newValue}
  }
  var hasOptionalNestedMessage: Bool {
    return _storage._optionalNestedMessage != nil
  }
  mutating func clearOptionalNestedMessage() {
    return _storage._optionalNestedMessage = nil
  }

  var options: OneOf_Options? {
    get {return _storage._options}
    set {
      _uniqueStorage()._options = newValue
    }
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_Options: Equatable {
    case oneofInt64(Int64)
    case oneofBool(Bool)
    case oneofString(String)
    case oneofInt32(Int32)

    static func ==(lhs: Swift_Protobuf_TestFieldOrderings.OneOf_Options, rhs: Swift_Protobuf_TestFieldOrderings.OneOf_Options) -> Bool {
      switch (lhs, rhs) {
      case (.oneofInt64(let l), .oneofInt64(let r)): return l == r
      case (.oneofBool(let l), .oneofBool(let r)): return l == r
      case (.oneofString(let l), .oneofString(let r)): return l == r
      case (.oneofInt32(let l), .oneofInt32(let r)): return l == r
      default: return false
      }
    }

    fileprivate init?<T: SwiftProtobuf.Decoder>(byDecodingFrom decoder: inout T, fieldNumber: Int) throws {
      switch fieldNumber {
      case 9:
        var value: Bool?
        try decoder.decodeSingularBoolField(value: &value)
        if let value = value {
          self = .oneofBool(value)
          return
        }
      case 10:
        var value: Int32?
        try decoder.decodeSingularInt32Field(value: &value)
        if let value = value {
          self = .oneofInt32(value)
          return
        }
      case 60:
        var value: Int64?
        try decoder.decodeSingularInt64Field(value: &value)
        if let value = value {
          self = .oneofInt64(value)
          return
        }
      case 150:
        var value: String?
        try decoder.decodeSingularStringField(value: &value)
        if let value = value {
          self = .oneofString(value)
          return
        }
      default:
        break
      }
      return nil
    }

    fileprivate func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V, start: Int, end: Int) throws {
      switch self {
      case .oneofBool(let v):
        if start <= 9 && 9 < end {
          try visitor.visitSingularBoolField(value: v, fieldNumber: 9)
        }
      case .oneofInt32(let v):
        if start <= 10 && 10 < end {
          try visitor.visitSingularInt32Field(value: v, fieldNumber: 10)
        }
      case .oneofInt64(let v):
        if start <= 60 && 60 < end {
          try visitor.visitSingularInt64Field(value: v, fieldNumber: 60)
        }
      case .oneofString(let v):
        if start <= 150 && 150 < end {
          try visitor.visitSingularStringField(value: v, fieldNumber: 150)
        }
      }
    }
  }

  struct NestedMessage: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = Swift_Protobuf_TestFieldOrderings.protoMessageName + ".NestedMessage"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
      2: .same(proto: "oo"),
      1: .same(proto: "bb"),
    ]

    private var _oo: Int64? = nil
    var oo: Int64 {
      get {return _oo ?? 0}
      set {_oo = newValue}
    }
    var hasOo: Bool {
      return _oo != nil
    }
    mutating func clearOo() {
      return _oo = nil
    }

    private var _bb: Int32? = nil
    var bb: Int32 {
      get {return _bb ?? 0}
      set {_bb = newValue}
    }
    var hasBb: Bool {
      return _bb != nil
    }
    mutating func clearBb() {
      return _bb = nil
    }

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 2: try decoder.decodeSingularInt64Field(value: &_oo)
        case 1: try decoder.decodeSingularInt32Field(value: &_bb)
        default: break
        }
      }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
      if let v = _bb {
        try visitor.visitSingularInt32Field(value: v, fieldNumber: 1)
      }
      if let v = _oo {
        try visitor.visitSingularInt64Field(value: v, fieldNumber: 2)
      }
      try unknownFields.traverse(visitor: &visitor)
    }

    func _protobuf_generated_isEqualTo(other: Swift_Protobuf_TestFieldOrderings.NestedMessage) -> Bool {
      if _oo != other._oo {return false}
      if _bb != other._bb {return false}
      if unknownFields != other.unknownFields {return false}
      return true
    }
  }

  init() {}

  public var isInitialized: Bool {
    if !_protobuf_extensionFieldValues.isInitialized {return false}
    return true
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 11: try decoder.decodeSingularStringField(value: &_storage._myString)
        case 1: try decoder.decodeSingularInt64Field(value: &_storage._myInt)
        case 101: try decoder.decodeSingularFloatField(value: &_storage._myFloat)
        case 9, 10, 60, 150:
          if _storage._options != nil {
            try decoder.handleConflictingOneOf()
          }
          _storage._options = try Swift_Protobuf_TestFieldOrderings.OneOf_Options(byDecodingFrom: &decoder, fieldNumber: fieldNumber)
        case 200: try decoder.decodeSingularMessageField(value: &_storage._optionalNestedMessage)
        case 2..<9, 12..<56:
          try decoder.decodeExtensionField(values: &_protobuf_extensionFieldValues, messageType: Swift_Protobuf_TestFieldOrderings.self, fieldNumber: fieldNumber)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._myInt {
        try visitor.visitSingularInt64Field(value: v, fieldNumber: 1)
      }
      try visitor.visitExtensionFields(fields: _protobuf_extensionFieldValues, start: 2, end: 9)
      try _storage._options?.traverse(visitor: &visitor, start: 9, end: 11)
      if let v = _storage._myString {
        try visitor.visitSingularStringField(value: v, fieldNumber: 11)
      }
      try visitor.visitExtensionFields(fields: _protobuf_extensionFieldValues, start: 12, end: 56)
      try _storage._options?.traverse(visitor: &visitor, start: 60, end: 61)
      if let v = _storage._myFloat {
        try visitor.visitSingularFloatField(value: v, fieldNumber: 101)
      }
      try _storage._options?.traverse(visitor: &visitor, start: 150, end: 151)
      if let v = _storage._optionalNestedMessage {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 200)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Swift_Protobuf_TestFieldOrderings) -> Bool {
    if _storage !== other._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((_storage, other._storage)) { (_storage, other_storage) in
        if _storage._myString != other_storage._myString {return false}
        if _storage._myInt != other_storage._myInt {return false}
        if _storage._myFloat != other_storage._myFloat {return false}
        if _storage._options != other_storage._options {return false}
        if _storage._optionalNestedMessage != other_storage._optionalNestedMessage {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if unknownFields != other.unknownFields {return false}
    if _protobuf_extensionFieldValues != other._protobuf_extensionFieldValues {return false}
    return true
  }

  var _protobuf_extensionFieldValues = SwiftProtobuf.ExtensionFieldValueSet()
}

let Swift_Protobuf_Extensions_my_extension_string = SwiftProtobuf.MessageExtension<OptionalExtensionField<SwiftProtobuf.ProtobufString>, Swift_Protobuf_TestFieldOrderings>(
  _protobuf_fieldNumber: 50,
  fieldName: "swift.protobuf.my_extension_string",
  defaultValue: ""
)

let Swift_Protobuf_Extensions_my_extension_int = SwiftProtobuf.MessageExtension<OptionalExtensionField<SwiftProtobuf.ProtobufInt32>, Swift_Protobuf_TestFieldOrderings>(
  _protobuf_fieldNumber: 5,
  fieldName: "swift.protobuf.my_extension_int",
  defaultValue: 0
)

extension Swift_Protobuf_TestFieldOrderings {
  var Swift_Protobuf_myExtensionString: String {
    get {return getExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_string) ?? ""}
    set {setExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_string, value: newValue)}
  }
  var hasSwift_Protobuf_myExtensionString: Bool {
    return hasExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_string)
  }
  mutating func clearSwift_Protobuf_myExtensionString() {
    clearExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_string)
  }
}

extension Swift_Protobuf_TestFieldOrderings {
  var Swift_Protobuf_myExtensionInt: Int32 {
    get {return getExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_int) ?? 0}
    set {setExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_int, value: newValue)}
  }
  var hasSwift_Protobuf_myExtensionInt: Bool {
    return hasExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_int)
  }
  mutating func clearSwift_Protobuf_myExtensionInt() {
    clearExtensionValue(ext: Swift_Protobuf_Extensions_my_extension_int)
  }
}

let Swift_Protobuf_UnittestSwiftFieldorder_Extensions: SwiftProtobuf.SimpleExtensionMap = [
  Swift_Protobuf_Extensions_my_extension_string,
  Swift_Protobuf_Extensions_my_extension_int
]
