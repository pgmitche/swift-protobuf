// Sources/protoc-gen-swift/ExtensionGenerator.swift - Handle Proto2 extension
//
// Copyright (c) 2014 - 2016 Apple Inc. and the project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information:
// https://github.com/apple/swift-protobuf/blob/master/LICENSE.txt
//
// -----------------------------------------------------------------------------
///
/// Each instance of ExtensionGenerator represents a single Proto2 extension
/// and contains the logic necessary to emit the various required sources.
/// Note that this wraps the same FieldDescriptorProto used by MessageFieldGenerator,
/// even though the Swift source emitted is very, very different.
///
// -----------------------------------------------------------------------------
import Foundation
import PluginLibrary
import SwiftProtobuf

class ExtensionGenerator {

    // Helper to hold all the extensions when generating things across all
    // the extensions within a given file.
    class Set {
        private let fileDescriptor: FileDescriptor
        private let generatorOptions: GeneratorOptions
        private let namer: SwiftProtobufNamer

        private var extensions: [ExtensionGenerator] = []

        var isEmpty: Bool { return extensions.isEmpty }

        init(
          fileDescriptor: FileDescriptor,
          generatorOptions: GeneratorOptions,
          namer: SwiftProtobufNamer
        ) {
            self.fileDescriptor = fileDescriptor
            self.generatorOptions = generatorOptions
            self.namer = namer
        }

        func register(extensions: [ExtensionGenerator]) {
            self.extensions.append(contentsOf: extensions)
        }

        func generateMessageSwiftExtensions(printer p: inout CodePrinter) {
            for e in extensions {
                e.generateMessageSwiftExtension(printer: &p)
            }
        }

        func generateFileProtobufExtensionRegistry(printer p: inout CodePrinter) {
            guard !extensions.isEmpty else { return }

            let pathParts = splitPath(pathname: fileDescriptor.name)
            let filenameAsIdentifer = NamingUtils.toUpperCamelCase(pathParts.base)
            let filePrefix = namer.typePrefix(forFile: fileDescriptor)
            p.print(
              "\n",
              "/// A `SwiftProtobuf.SimpleExtensionMap` that includes all of the extensions defined by\n",
              "/// this .proto file. It can be used any place an `SwiftProtobuf.ExtensionMap` is needed\n",
              "/// in parsing, or it can be combined with other `SwiftProtobuf.SimpleExtensionMap`s to create\n",
              "/// a larger `SwiftProtobuf.SimpleExtensionMap`.\n",
              "\(generatorOptions.visibilitySourceSnippet)let \(filePrefix)\(filenameAsIdentifer)_Extensions: SwiftProtobuf.SimpleExtensionMap = [\n")
            p.indent()
            var separator = ""
            for e in extensions {
                p.print(separator, e.swiftFullExtensionName)
                separator = ",\n"
            }
            p.print("\n")
            p.outdent()
            p.print("]\n")

        }
    }

    private let fieldDescriptor: FieldDescriptor
    private let generatorOptions: GeneratorOptions
    private let namer: SwiftProtobufNamer

    private let comments: String
    private let containingTypeSwiftFullName: String
    private let swiftFullExtensionName: String

    private var extensionFieldType: String {
        let label: String
        switch fieldDescriptor.label {
        case .optional: label = "Optional"
        case .required: label = "Required"
        case .repeated: label = fieldDescriptor.isPacked ? "Packed" : "Repeated"
        }

        let modifier: String
        switch fieldDescriptor.type {
        case .group: modifier = "Group"
        case .message: modifier = "Message"
        case .enum: modifier = "Enum"
        default: modifier = ""
        }

        return "SwiftProtobuf.\(label)\(modifier)ExtensionField"
    }

    init(descriptor: FieldDescriptor, generatorOptions: GeneratorOptions, namer: SwiftProtobufNamer) {
        self.fieldDescriptor = descriptor
        self.generatorOptions = generatorOptions
        self.namer = namer

        swiftFullExtensionName = namer.fullName(extensionField: descriptor)

        comments = descriptor.protoSourceComments()
        containingTypeSwiftFullName = namer.fullName(message: fieldDescriptor.containingType)
    }

    func generateProtobufExtensionDeclarations(printer p: inout CodePrinter) {
        let scope = fieldDescriptor.extensionScope == nil ? "" : "static "
        let traitsType = fieldDescriptor.traitsType(namer: namer)
        let swiftRelativeExtensionName = namer.relativeName(extensionField: fieldDescriptor)

        var fieldNamePath = fieldDescriptor.fullName
        assert(fieldNamePath.hasPrefix("."))
        fieldNamePath.remove(at: fieldNamePath.startIndex)  // Remove the leading '.'

        p.print(
          comments,
          "\(scope)let \(swiftRelativeExtensionName) = SwiftProtobuf.MessageExtension<\(extensionFieldType)<\(traitsType)>, \(containingTypeSwiftFullName)>(\n")
        p.indent()
        p.print(
          "_protobuf_fieldNumber: \(fieldDescriptor.number),\n",
          "fieldName: \"\(fieldNamePath)\"\n")
        p.outdent()
        p.print(")\n")
    }

    func generateMessageSwiftExtension(printer p: inout CodePrinter) {
        let visibility = generatorOptions.visibilitySourceSnippet
        let apiType = fieldDescriptor.swiftType(namer: namer)
        let extensionNames = namer.messagePropertyNames(extensionField: fieldDescriptor)
        let defaultValue = fieldDescriptor.swiftDefaultValue(namer: namer)

        p.print("\n")
        p.print("extension \(containingTypeSwiftFullName) {\n")
        p.indent()
        p.print(
          comments,
          "\(visibility)var \(extensionNames.value): \(apiType) {\n")
        p.indent()
        p.print(
          "get {return getExtensionValue(ext: \(swiftFullExtensionName)) ?? \(defaultValue)}\n",
          "set {setExtensionValue(ext: \(swiftFullExtensionName), value: newValue)}\n")
        p.outdent()
        p.print("}\n")

        p.print(
            "/// Returns true if extension `\(swiftFullExtensionName)`\n/// has been explicitly set.\n",
            "\(visibility)var \(extensionNames.has): Bool {\n")
        p.indent()
        p.print("return hasExtensionValue(ext: \(swiftFullExtensionName))\n")
        p.outdent()
        p.print("}\n")

        p.print(
            "/// Clears the value of extension `\(swiftFullExtensionName)`.\n/// Subsequent reads from it will return its default value.\n",
            "\(visibility)mutating func \(extensionNames.clear)() {\n")
        p.indent()
        p.print("clearExtensionValue(ext: \(swiftFullExtensionName))\n")
        p.outdent()
        p.print("}\n")
        p.outdent()
        p.print("}\n")
    }
}
