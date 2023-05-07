// Sources/protoc-gen-swift/FileGenerator.swift - File-level generation logic
//
// Copyright (c) 2014 - 2016 Apple Inc. and the project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information:
// https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt
//
// -----------------------------------------------------------------------------
///
/// This provides the logic for each file that is stored in the plugin request.
/// In particular, generateOutputFile() actually builds a Swift source file
/// to represent a single .proto input.  Note that requests typically contain
/// a number of proto files that are not to be generated.
///
// -----------------------------------------------------------------------------
import Foundation
import SwiftProtobufPluginLibrary
import SwiftProtobuf


class FileGenerator {
    private let fileDescriptor: FileDescriptor
    private let generatorOptions: GeneratorOptions
    private let namer: SwiftProtobufNamer

    var outputFilename: String {
        let ext = ".pb.swift"
        let pathParts = splitPath(pathname: fileDescriptor.name)
        switch generatorOptions.outputNaming {
        case .fullPath:
            return pathParts.dir + pathParts.base + ext
        case .pathToUnderscores:
            let dirWithUnderscores =
                pathParts.dir.replacingOccurrences(of: "/", with: "_")
            return dirWithUnderscores + pathParts.base + ext
        case .dropPath:
            return pathParts.base + ext
        }
    }

    init(fileDescriptor: FileDescriptor,
         generatorOptions: GeneratorOptions) {
        self.fileDescriptor = fileDescriptor
        self.generatorOptions = generatorOptions
        namer = SwiftProtobufNamer(currentFile: fileDescriptor,
                                   protoFileToModuleMappings: generatorOptions.protoToModuleMappings)
    }

    /// Generate, if `errorString` gets filled in, then report error instead of using
    /// what written into `printer`.
    func generateOutputFile(printer p: inout CodePrinter, errorString: inout String?) {
        guard fileDescriptor.options.swiftPrefix.isEmpty ||
            isValidSwiftIdentifier(fileDescriptor.options.swiftPrefix,
                                   allowQuoted: false) else {
          errorString = "\(fileDescriptor.name) has an 'swift_prefix' that isn't a valid Swift identifier (\(fileDescriptor.options.swiftPrefix))."
          return
        }
        p.print("""
            // DO NOT EDIT.
            // swift-format-ignore-file
            //
            // Generated by the Swift generator plugin for the protocol buffer compiler.
            // Source: \(fileDescriptor.name)
            //
            // For information on using the generated types, please see the documentation:
            //   https://github.com/apple/swift-protobuf/

            """)

        // Attempt to bring over the comments at the top of the .proto file as
        // they likely contain copyrights/preamble/etc.
        //
        // The C++ FileDescriptor::GetSourceLocation(), says the location for
        // the file is an empty path. That never seems to have comments on it.
        // https://github.com/protocolbuffers/protobuf/issues/2249 opened to
        // figure out the right way to do this since the syntax entry is
        // optional.
        var comments = String()
        let syntaxPath = IndexPath(index: Google_Protobuf_FileDescriptorProto.FieldNumbers.syntax)
        if let syntaxLocation = fileDescriptor.sourceCodeInfoLocation(path: syntaxPath) {
          comments = syntaxLocation.asSourceComment(commentPrefix: "///",
                                                    leadingDetachedPrefix: "//")
          // If the was a leading or tailing comment it won't have a blank
          // line, after it, so ensure there is one.
          if !comments.isEmpty && !comments.hasSuffix("\n\n") {
            comments.append("\n")
          }
        }

        p.print("\(comments)import Foundation")
        if !fileDescriptor.isBundledProto {
            // The well known types ship with the runtime, everything else needs
            // to import the runtime.
            p.print("import \(namer.swiftProtobufModuleName)")
        }
        if let neededImports = generatorOptions.protoToModuleMappings.neededModules(forFile: fileDescriptor) {
            p.print()
            for i in neededImports {
                p.print("import \(i)")
            }
        }
        if let neededCustomImports = generatorOptions.extraModuleImports {
            p.print()
            for i in neededCustomImports {
                p.print("import \(i)\n")
            }
        }

        p.print()
        generateVersionCheck(printer: &p)

        let extensionSet =
            ExtensionSetGenerator(fileDescriptor: fileDescriptor,
                                  generatorOptions: generatorOptions,
                                  namer: namer)

        extensionSet.add(extensionFields: fileDescriptor.extensions)

        let enums = fileDescriptor.enums.map {
            return EnumGenerator(descriptor: $0, generatorOptions: generatorOptions, namer: namer)
        }

        let messages = fileDescriptor.messages.map {
          return MessageGenerator(descriptor: $0,
                                  generatorOptions: generatorOptions,
                                  namer: namer,
                                  extensionSet: extensionSet)
        }

        for e in enums {
            e.generateMainEnum(printer: &p)
        }

        for m in messages {
            m.generateMainStruct(printer: &p, parent: nil, errorString: &errorString)
        }

        var sendablePrinter = CodePrinter(p)
        for m in messages {
            m.generateSendable(printer: &sendablePrinter)
        }

        if !sendablePrinter.isEmpty {
            p.print("", "#if swift(>=5.5) && canImport(_Concurrency)")
            p.append(sendablePrinter)
            p.print("#endif  // swift(>=5.5) && canImport(_Concurrency)")
        }

        if !extensionSet.isEmpty {
            let pathParts = splitPath(pathname: fileDescriptor.name)
            let filename = pathParts.base + pathParts.suffix
            p.print(
                "",
                "// MARK: - Extension support defined in \(filename).")

            // Generate the Swift Extensions on the Messages that provide the api
            // for using the protobuf extension.
            extensionSet.generateMessageSwiftExtensions(printer: &p)

            // Generate a registry for the file.
            extensionSet.generateFileProtobufExtensionRegistry(printer: &p)

            // Generate the Extension's declarations (used by the two above things).
            //
            // This is done after the other two as the only time developers will need
            // these symbols is if they are manually building their own ExtensionMap;
            // so the others are assumed more interesting.
            extensionSet.generateProtobufExtensionDeclarations(printer: &p)
        }

        let protoPackage = fileDescriptor.package
        let needsProtoPackage: Bool = !protoPackage.isEmpty && !messages.isEmpty
        if needsProtoPackage || !enums.isEmpty || !messages.isEmpty {
            p.print(
                "",
                "// MARK: - Code below here is support for the SwiftProtobuf runtime.")
            if needsProtoPackage {
                p.print(
                    "",
                    "fileprivate let _protobuf_package = \"\(protoPackage)\"")
            }
            for e in enums {
                e.generateRuntimeSupport(printer: &p)
            }
            for m in messages {
                m.generateRuntimeSupport(printer: &p, file: self, parent: nil)
            }
        }
    }

    private func generateVersionCheck(printer p: inout CodePrinter) {
        let v = Version.compatibilityVersion
        p.print("""
            // If the compiler emits an error on this type, it is because this file
            // was generated by a version of the `protoc` Swift plug-in that is
            // incompatible with the version of SwiftProtobuf to which you are linking.
            // Please ensure that you are building against the same version of the API
            // that was used to generate this file.
            fileprivate struct _GeneratedWithProtocGenSwiftVersion: \(namer.swiftProtobufModulePrefix)ProtobufAPIVersionCheck {
            """)
        p.printIndented(
            "struct _\(v): \(namer.swiftProtobufModulePrefix)ProtobufAPIVersion_\(v) {}",
            "typealias Version = _\(v)")
        p.print("}")
    }
}
