// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_gym_machine_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myGymMachineViewModelHash() =>
    r'e1c82d6181f1f376e35ebff04da8928c613bee10';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MyGymMachineViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<CustomMachine>> {
  late final int gymId;

  FutureOr<List<CustomMachine>> build(
    int gymId,
  );
}

/// See also [MyGymMachineViewModel].
@ProviderFor(MyGymMachineViewModel)
const myGymMachineViewModelProvider = MyGymMachineViewModelFamily();

/// See also [MyGymMachineViewModel].
class MyGymMachineViewModelFamily
    extends Family<AsyncValue<List<CustomMachine>>> {
  /// See also [MyGymMachineViewModel].
  const MyGymMachineViewModelFamily();

  /// See also [MyGymMachineViewModel].
  MyGymMachineViewModelProvider call(
    int gymId,
  ) {
    return MyGymMachineViewModelProvider(
      gymId,
    );
  }

  @override
  MyGymMachineViewModelProvider getProviderOverride(
    covariant MyGymMachineViewModelProvider provider,
  ) {
    return call(
      provider.gymId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myGymMachineViewModelProvider';
}

/// See also [MyGymMachineViewModel].
class MyGymMachineViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MyGymMachineViewModel,
        List<CustomMachine>> {
  /// See also [MyGymMachineViewModel].
  MyGymMachineViewModelProvider(
    int gymId,
  ) : this._internal(
          () => MyGymMachineViewModel()..gymId = gymId,
          from: myGymMachineViewModelProvider,
          name: r'myGymMachineViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myGymMachineViewModelHash,
          dependencies: MyGymMachineViewModelFamily._dependencies,
          allTransitiveDependencies:
              MyGymMachineViewModelFamily._allTransitiveDependencies,
          gymId: gymId,
        );

  MyGymMachineViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gymId,
  }) : super.internal();

  final int gymId;

  @override
  FutureOr<List<CustomMachine>> runNotifierBuild(
    covariant MyGymMachineViewModel notifier,
  ) {
    return notifier.build(
      gymId,
    );
  }

  @override
  Override overrideWith(MyGymMachineViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyGymMachineViewModelProvider._internal(
        () => create()..gymId = gymId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gymId: gymId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MyGymMachineViewModel,
      List<CustomMachine>> createElement() {
    return _MyGymMachineViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyGymMachineViewModelProvider && other.gymId == gymId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gymId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyGymMachineViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<CustomMachine>> {
  /// The parameter `gymId` of this provider.
  int get gymId;
}

class _MyGymMachineViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MyGymMachineViewModel,
        List<CustomMachine>> with MyGymMachineViewModelRef {
  _MyGymMachineViewModelProviderElement(super.provider);

  @override
  int get gymId => (origin as MyGymMachineViewModelProvider).gymId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
