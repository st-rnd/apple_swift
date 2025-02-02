// RUN: %empty-directory(%t)

// RUN: %target-swift-frontend -emit-module -emit-module-path %t/ImplementationOnlyDefs.swiftmodule -module-name ImplementationOnlyDefs %S/Inputs/ImplementationOnlyDefs.swift \
// RUN:   -enable-library-evolution -swift-version 5
// RUN: %target-swift-frontend -disable-availability-checking -I %t -enable-library-evolution -swift-version 5 -emit-sil -o /dev/null -verify %s
// RUN: %target-swift-frontend -disable-availability-checking -I %t -enable-library-evolution -swift-version 5 -emit-sil -o /dev/null -verify -strict-concurrency=targeted %s
// RUN: %target-swift-frontend -disable-availability-checking -I %t -enable-library-evolution -swift-version 5 -emit-sil -o /dev/null -verify -strict-concurrency=complete %s
// RUN: %target-swift-frontend -disable-availability-checking -I %t -enable-library-evolution -swift-version 5 -emit-sil -o /dev/null -verify -strict-concurrency=complete -enable-experimental-feature SendNonSendable %s

// REQUIRES: concurrency

@_implementationOnly import ImplementationOnlyDefs

class D: C {
  @_implementationOnly
  override func f(_: @escaping () -> Void) { }

  @_implementationOnly
  override func g(_: @escaping () -> Void) -> BSub { BSub() }
  // expected-error@-1{{'@_implementationOnly' override must have the same type as the declaration it overrides ('(@escaping () -> Void) -> BSuper')}}
}
