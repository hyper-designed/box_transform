// Comprehensive combinatorial benchmark suite for box_transform.
//
// Methodology:
//
// * Each scenario runs `kBatches` batches of `kBatchSize` calls. Per-call
//   wall time is computed as batch_us * 1000 / batchSize, then we report
//   percentiles across batches (min/p50/mean/p95/p99/max). Batching amortizes
//   Stopwatch overhead (~30-100 ns/start-stop) below 1% of measurement. See
//   Shipilëv, "Nanotrusting the Nanotime", https://shipilev.net/blog/2014/nanotrusting-nanotime/
//   for the canonical writeup of why naive start;op;stop loops lie.
//
// * `kWarmup` calls precede measurement to reach steady state. Matters even
//   in AOT for cold-cache effects, and in JIT for tier-up. The warmup-then-
//   measure pattern is JMH's idiom and is the same pattern Dart's official
//   `package:benchmark_harness` uses (https://pub.dev/packages/benchmark_harness).
//
// * A global `sink` accumulates result hashes so AOT cannot elide the work.
//   Direct adaptation of JMH's `Blackhole` sink; see Oracle, "Avoiding
//   Benchmarking Pitfalls on the JVM", https://www.oracle.com/technical-resources/articles/java/architect-benchmarking.html
//   for the dead-code-elimination problem this solves. Dart-side guidance
//   from Egorov, "Microbenchmarking Dart, Part 1",
//   https://mrale.ph/blog/2021/01/21/microbenchmarking-dart-part-1.html.
//
// * We report p95/p99/max alongside the mean so the tail is visible (GC
//   pauses, OS context switches, slow-path branches). Reporting only the
//   mean hides those; see Gil Tene's coordinated-omission writeups and
//   HdrHistogram (https://github.com/HdrHistogram/HdrHistogram).
//
// * Scenarios are generated from axis grids, not hand-rolled. Guarantees
//   coverage and makes the matrix self-documenting.
//
// Run with AOT for production-equivalent numbers:
//   dart compile exe benchmark/comprehensive_bench.dart -o /tmp/bbench
//   /tmp/bbench

import 'dart:io';
import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:vector_math/vector_math_64.dart';

// Warmup count and batch dimensions adapted from JMH's warmup-then-measure
// shape, collapsed into a single process (Dart's AOT does not need JMH's
// fork isolation). See https://openjdk.org/projects/code-tools/jmh/.
const int kWarmup = 4000;
const int kBatches = 25;
const int kBatchSize = 4000;

/// Sink to defeat dead-code elimination. Each benchmark XORs result bits
/// into this. Print at end so AOT must keep the work.
///
/// Same pattern as JMH's `Blackhole.consume(...)`. Without it, the AOT
/// compiler is free to delete the measured loop because no observable
/// state depends on the result. See Oracle's "Avoiding Benchmarking
/// Pitfalls on the JVM" and Egorov's "Microbenchmarking Dart, Part 1"
/// (linked at the top of this file) for the underlying rationale.
int sink = 0;

void main() {
  _printHeader();

  final results = <BenchResult>[];
  results.addAll(_moveScenarios());
  results.addAll(_resizeScenarios());
  results.addAll(_rotateScenarios());
  results.addAll(_reclampScenarios());

  _printResults(results);

  // Force the compiler to keep all work.
  stderr.writeln('# sink=${sink.toRadixString(16)}');
}

// ---------------------------------------------------------------------------
// Stats / harness
// ---------------------------------------------------------------------------

/// Per-scenario statistics. p95/p99/max are reported alongside the mean
/// so the tail (GC pauses, context switches, slow-path branches) stays
/// visible. Collapsing the distribution to a single number is the
/// failure mode Gil Tene calls coordinated omission; see
/// https://github.com/HdrHistogram/HdrHistogram.
class Stats {
  final double minNs, p50Ns, p95Ns, p99Ns, maxNs, meanNs, stddevNs;
  Stats(this.minNs, this.p50Ns, this.p95Ns, this.p99Ns, this.maxNs, this.meanNs,
      this.stddevNs);

  static Stats from(List<double> nsPerOp) {
    final s = List<double>.from(nsPerOp)..sort();
    final n = s.length;
    final mean = s.reduce((a, b) => a + b) / n;
    var sq = 0.0;
    for (final v in s) {
      sq += (v - mean) * (v - mean);
    }
    final stddev = math.sqrt(sq / n);
    // Compute percentiles by index into the sorted batch list. We sample
    // p50, p95, p99 (plus min/max from the sorted ends) so the tail is
    // visible alongside the mean. HdrHistogram convention; the tail is
    // where coordinated-omission failures hide and where users feel
    // slow frames.
    double pct(double p) {
      final idx = ((n - 1) * p).round();
      return s[idx];
    }

    return Stats(
        s.first, pct(0.50), pct(0.95), pct(0.99), s.last, mean, stddev);
  }
}

class BenchResult {
  final String category;
  final String scenario;
  final Stats stats;
  BenchResult(this.category, this.scenario, this.stats);
  double get opsPerSec => 1e9 / stats.meanNs;
}

/// Run one warmup pass, then [kBatches] timed batches of [kBatchSize] calls.
/// `Stopwatch.elapsedMicroseconds` has ~30-100 ns of start/stop overhead on
/// modern CPUs; batching amortizes that below 0.1% of the per-op figure.
/// Pattern adapted from JMH and `package:benchmark_harness`; see
/// top-of-file references.
BenchResult _bench(String category, String scenario, void Function(int) fn) {
  // Warmup: drive the AOT code through any cold-cache and tier-up
  // effects before the first measured batch. JMH idiom; see
  // `package:benchmark_harness` for the Dart equivalent.
  fn(kWarmup);
  final batchTimes = <double>[];
  for (int b = 0; b < kBatches; b++) {
    // One Stopwatch start/stop per batch (not per op): ~30-100 ns of
    // clock-source overhead is amortized across kBatchSize calls,
    // dropping below 0.1% of the per-op figure. This is exactly the
    // amortization Shipilëv argues for in "Nanotrusting the Nanotime";
    // a per-op start;op;stop loop would inflate every measurement by
    // its own clock cost.
    final sw = Stopwatch()..start();
    fn(kBatchSize);
    sw.stop();
    // ns/op derived from microsecond resolution: micros × 1000 / N.
    // Stopwatch.elapsedMicroseconds is the highest-resolution clock
    // the Dart VM exposes that's portable across AOT and JIT.
    batchTimes.add(sw.elapsedMicroseconds * 1000.0 / kBatchSize);
  }
  return BenchResult(category, scenario, Stats.from(batchTimes));
}

// ---------------------------------------------------------------------------
// Delta patterns
//
// Each pattern returns a (start: Vector2, fn: i -> Vector2) pair. The fn
// is what the loop calls; start is what we feed as initialLocalPosition.
// ---------------------------------------------------------------------------

typedef DeltaPattern = ({Vector2 start, Vector2 Function(int i) at});

DeltaPattern _smooth(Vector2 origin) => (
      start: origin,
      at: (i) => Vector2(origin.x + i * 0.1, origin.y + i * 0.07)
    );

DeltaPattern _subpixel(Vector2 origin) => (
      start: origin,
      at: (i) => Vector2(origin.x + i * 0.001, origin.y + i * 0.0007)
    );

// PRNG with stable seed: ±1px jitter on top of slow drift.
DeltaPattern _jitter(Vector2 origin) {
  final rng = math.Random(0xb0a);
  return (
    start: origin,
    at: (i) => Vector2(
          origin.x + i * 0.05 + (rng.nextDouble() - 0.5) * 2,
          origin.y + i * 0.03 + (rng.nextDouble() - 0.5) * 2,
        )
  );
}

// Edge-saturated: pointer ranges WAY outside the clamp, forcing the
// projector/interval-clamp to pin every call.
DeltaPattern _saturated(Vector2 origin) => (
      start: origin,
      at: (i) =>
          Vector2(origin.x + 5000.0 + i * 0.1, origin.y + 5000.0 + i * 0.1)
    );

const _patterns = <String, DeltaPattern Function(Vector2)>{
  'smooth': _smooth,
  'subpix': _subpixel,
  'jitter': _jitter,
  'saturated': _saturated,
};

// ---------------------------------------------------------------------------
// Geometry helpers for scenario building
// ---------------------------------------------------------------------------

const _baseW = 100.0;
const _baseH = 100.0;
const _cx = 500.0;
const _cy = 500.0;

Box _makeRect(double rotation) =>
    Box.fromLTWH(_cx - _baseW / 2, _cy - _baseH / 2, _baseW, _baseH,
        rotation: rotation);

Box _makeClamp(String mode, double rotation) {
  // 'none' uses Box.largest. 'loose' = generous container. 'saturated' =
  // exactly the bounding rect of the rotated box (single feasible point
  // for move; minimal slack for resize).
  switch (mode) {
    case 'none':
      return Box.largest;
    case 'loose':
      return Box.fromLTRB(0, 0, 1000, 1000);
    case 'saturated':
      final rect = _makeRect(rotation);
      final br = ClampHelpers.calculateBoundingRect(rect);
      return Box.fromLTRB(br.left, br.top, br.right, br.bottom);
    default:
      throw ArgumentError(mode);
  }
}

Constraints _makeConstraints(String mode) {
  switch (mode) {
    case 'none':
      return const Constraints.unconstrained();
    case 'loose':
      return const Constraints(
          minWidth: 10, maxWidth: 1000, minHeight: 10, maxHeight: 1000);
    case 'tight':
      // Centered tightly around current size (100×100); exercises min/max
      // hit paths since the projector pins to bounds frequently.
      return const Constraints(
          minWidth: 90, maxWidth: 110, minHeight: 90, maxHeight: 110);
    default:
      throw ArgumentError(mode);
  }
}

// ---------------------------------------------------------------------------
// MOVE scenarios
// ---------------------------------------------------------------------------

Iterable<BenchResult> _moveScenarios() sync* {
  final rotations = <(String, double)>[
    ('θ=0', 0.0),
    ('θ=π/6', math.pi / 6),
  ];
  final clamps = ['none', 'loose', 'saturated'];
  final strategies = <(String, BindingStrategy)>[
    ('orig', BindingStrategy.originalBox),
    ('bbox', BindingStrategy.boundingBox),
  ];
  for (final (rotLabel, rotation) in rotations) {
    for (final clampMode in clamps) {
      for (final (stratLabel, strat) in strategies) {
        // Strategy is meaningless at θ=0; only run once.
        if (rotation == 0.0 && stratLabel != 'orig') continue;
        for (final patternName in _patterns.keys) {
          final pattern = _patterns[patternName]!(Vector2(_cx, _cy));
          final rect = _makeRect(rotation);
          final clamp = _makeClamp(clampMode, rotation);

          final label = rotation == 0.0
              ? 'clamp=$clampMode | delta=$patternName | $rotLabel'
              : 'clamp=$clampMode | delta=$patternName | $rotLabel | strat=$stratLabel';

          yield _bench('MOVE', label, (n) {
            for (int i = 0; i < n; i++) {
              final r = BoxTransformer.move(
                initialRect: rect,
                initialLocalPosition: pattern.start,
                localPosition: pattern.at(i),
                clampingRect: clamp,
                rotation: rotation,
                bindingStrategy: strat,
              );
              // XOR result bits into the global `sink` so AOT cannot
              // dead-code-eliminate the whole loop. JMH `Blackhole`
              // pattern; see top-of-file references.
              sink ^= r.rect.left.toInt();
            }
          });
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// RESIZE scenarios: mode × rotation × clamping × constraints × strategy × delta.
// ---------------------------------------------------------------------------

Iterable<BenchResult> _resizeScenarios() sync* {
  final modes = <(String, ResizeMode)>[
    ('free', ResizeMode.freeform),
    ('scale', ResizeMode.scale),
    ('sym', ResizeMode.symmetric),
    ('symscale', ResizeMode.symmetricScale),
  ];
  final rotations = <(String, double)>[
    ('θ=0', 0.0),
    ('θ=π/6', math.pi / 6),
  ];
  final clamps = ['none', 'loose', 'saturated'];
  final cons = ['none', 'loose', 'tight'];
  final strategies = <(String, BindingStrategy)>[
    ('orig', BindingStrategy.originalBox),
    ('bbox', BindingStrategy.boundingBox),
  ];

  // Pointer originates at the unrotated bottom-right corner of the rect.
  final start = Vector2(_cx + _baseW / 2, _cy + _baseH / 2);

  for (final (modeLabel, mode) in modes) {
    for (final (rotLabel, rotation) in rotations) {
      for (final clampMode in clamps) {
        for (final consMode in cons) {
          for (final (stratLabel, strat) in strategies) {
            if (rotation == 0.0 && stratLabel != 'orig') continue;
            for (final patternName in _patterns.keys) {
              final pattern = _patterns[patternName]!(start);
              final rect = _makeRect(rotation);
              final clamp = _makeClamp(clampMode, rotation);
              final constraints = _makeConstraints(consMode);

              final label = rotation == 0.0
                  ? 'mode=$modeLabel | clamp=$clampMode | cons=$consMode | delta=$patternName | $rotLabel'
                  : 'mode=$modeLabel | clamp=$clampMode | cons=$consMode | delta=$patternName | $rotLabel | strat=$stratLabel';

              yield _bench('RESIZE', label, (n) {
                for (int i = 0; i < n; i++) {
                  final r = BoxTransformer.resize(
                    initialRect: rect,
                    initialLocalPosition: pattern.start,
                    localPosition: pattern.at(i),
                    handle: HandlePosition.bottomRight,
                    resizeMode: mode,
                    initialFlip: Flip.none,
                    clampingRect: clamp,
                    constraints: constraints,
                    rotation: rotation,
                    bindingStrategy: strat,
                  );
                  sink ^=
                      r.rect.right.toInt(); // sink fold; see _moveScenarios.
                }
              });
            }
          }
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// ROTATE scenarios: single op, no real combinatorics, vary delta only.
// ---------------------------------------------------------------------------

Iterable<BenchResult> _rotateScenarios() sync* {
  final rect = _makeRect(0.0);
  final start = Vector2(_cx + _baseW, _cy);
  for (final patternName in _patterns.keys) {
    final pattern = _patterns[patternName]!(start);
    yield _bench('ROTATE', 'delta=$patternName', (n) {
      for (int i = 0; i < n; i++) {
        final r = BoxTransformer.rotate(
          initialRect: rect,
          initialLocalPosition: pattern.start,
          localPosition: pattern.at(i),
          initialRotation: 0.0,
        );
        sink ^= r.rotation.toInt(); // sink fold; see _moveScenarios.
      }
    });
  }
}

// ---------------------------------------------------------------------------
// RECLAMP: "the parent container shrinks while a box is inside it".
// We model this as zero-delta `move()` with a clamp that shrinks each tick.
// This is what a UI controller does when the parent's available space changes.
// ---------------------------------------------------------------------------

Iterable<BenchResult> _reclampScenarios() sync* {
  final rotations = <(String, double)>[
    ('θ=0', 0.0),
    ('θ=π/6', math.pi / 6),
  ];
  // Three patterns of clamp-shrinkage:
  //  * 'shrink-loose': clamp starts huge, shrinks 1px/tick, never crosses box.
  //  * 'shrink-touch': clamp shrinks until it kisses the bounding rect.
  //  * 'shrink-cross': clamp shrinks past the bounding rect (infeasibility).
  final patterns = <String, Box Function(int i, double rotation)>{
    'shrink-loose': (i, rot) => Box.fromLTRB(
          200.0 - i * 0.1,
          200.0 - i * 0.1,
          800.0 + i * 0.1,
          800.0 + i * 0.1,
        ),
    'shrink-touch': (i, rot) {
      // Linearly interpolate from huge clamp toward exact bounding rect.
      final rect = _makeRect(rot);
      final br = ClampHelpers.calculateBoundingRect(rect);
      final t = (i % 1000) / 1000.0; // 0..1 cycling
      return Box.fromLTRB(
        50 + (br.left - 50) * t,
        50 + (br.top - 50) * t,
        950 + (br.right - 950) * t,
        950 + (br.bottom - 950) * t,
      );
    },
    'shrink-cross': (i, rot) {
      // Past the bounding rect (infeasible global interval); exercises the
      // collapse-to-midpoint sanitiser.
      final rect = _makeRect(rot);
      final br = ClampHelpers.calculateBoundingRect(rect);
      final shrinkPx = (i % 100) * 0.1; // up to 10px of infeasibility
      return Box.fromLTRB(
        br.left + shrinkPx,
        br.top + shrinkPx,
        br.right - shrinkPx,
        br.bottom - shrinkPx,
      );
    },
  };

  for (final (rotLabel, rotation) in rotations) {
    final rect = _makeRect(rotation);
    final start = Vector2(_cx, _cy);
    for (final entry in patterns.entries) {
      final patternName = entry.key;
      final clampFn = entry.value;
      yield _bench('RECLAMP', 'pattern=$patternName | $rotLabel', (n) {
        for (int i = 0; i < n; i++) {
          final clamp = clampFn(i, rotation);
          final r = BoxTransformer.move(
            initialRect: rect,
            initialLocalPosition: start,
            localPosition: start,
            clampingRect: clamp,
            rotation: rotation,
          );
          sink ^= r.rect.left.toInt(); // sink fold; see _moveScenarios.
        }
      });
    }
  }
}

// ---------------------------------------------------------------------------
// Output formatting
// ---------------------------------------------------------------------------

void _printHeader() {
  print('# box_transform: comprehensive benchmark report');
  print('');
  print('## Environment');
  print('- Dart: ${Platform.version}');
  print('- OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
  print('- Mode: ${_isAot() ? 'AOT' : 'JIT'}');
  print('');
  print('## Methodology');
  print('- $kBatches batches × $kBatchSize calls per scenario after $kWarmup '
      'warmup calls.');
  print('- ns/op = batch_us × 1000 / batchSize. Stopwatch overhead amortizes '
      'to <0.1% of measurement.');
  print('- Reported: min, p50, mean, p95, p99, max across batches; ops/sec '
      'derived from mean.');
  print('- Sink XOR-fold of every result blocks dead-code elimination.');
  print('- Scenarios cover the orthogonal axes of box_transform: operation × '
      'rotation × clamping state × constraints × binding strategy × pointer '
      'delta pattern.');
  print('');
}

void _printResults(List<BenchResult> all) {
  // Group by category.
  final byCat = <String, List<BenchResult>>{};
  for (final r in all) {
    byCat.putIfAbsent(r.category, () => []).add(r);
  }

  // Headline summary first.
  print('## Headline numbers (mean ns/op)');
  print('');
  print('| Category | Min | Median | Max | Cells |');
  print('|---|---:|---:|---:|---:|');
  for (final cat in byCat.keys) {
    final means = byCat[cat]!.map((r) => r.stats.meanNs).toList()..sort();
    final n = means.length;
    final mn = means.first.toStringAsFixed(0);
    final med = means[n ~/ 2].toStringAsFixed(0);
    final mx = means.last.toStringAsFixed(0);
    print('| $cat | $mn | $med | $mx | $n |');
  }
  print('');

  for (final cat in byCat.keys) {
    print('## $cat: ${byCat[cat]!.length} scenarios');
    print('');
    print('| Scenario | min | p50 | mean | p95 | p99 | max | ops/sec |');
    print('|---|---:|---:|---:|---:|---:|---:|---:|');
    final list = byCat[cat]!.toList()
      ..sort((a, b) => a.scenario.compareTo(b.scenario));
    for (final r in list) {
      final s = r.stats;
      print('| ${r.scenario} '
          '| ${s.minNs.toStringAsFixed(0)} '
          '| ${s.p50Ns.toStringAsFixed(0)} '
          '| ${s.meanNs.toStringAsFixed(0)} '
          '| ${s.p95Ns.toStringAsFixed(0)} '
          '| ${s.p99Ns.toStringAsFixed(0)} '
          '| ${s.maxNs.toStringAsFixed(0)} '
          '| ${r.opsPerSec.toStringAsFixed(0)} |');
    }
    print('');
  }
}

bool _isAot() {
  bool aot = true;
  assert(() {
    aot = false;
    return true;
  }());
  return aot;
}
