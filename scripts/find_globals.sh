#!/usr/bin/env bash
# Enumerate top-level (global) function declarations in lib/ files of both
# packages. Anything matching one of these patterns at column 0 is a
# top-level function:
#
#   <returnType> <name>(...)        // returns a value
#   void <name>(...)                // void
#   <returnType> <name><...>(...)   // generic
#   Future<...> <name>(...)         // async
#   <name>(...)                     // bare (no return type, rare)
#
# Excludes class members (those are indented under a class) and getters.
# Imperfect but good enough as a worklist seed: the user can verify each
# hit before refactoring.

set -euo pipefail
cd "$(dirname "$0")/../packages"

# Match a line that:
#   * starts at column 0
#   * begins with a Dart identifier or one of: void / Future / Iterable / List / Map / Set / Stream / FutureOr / Box / Vector2 / Offset / Rect / Size / Constraints / Resizer / Flip / HandlePosition / RotateResult / ResizeResult / MoveResult / RawResizeResult / RawMoveResult / RawRotateResult / Box? / int / double / bool / String / num
#   * (followed by name, optional generics, '(' )
#   * and is NOT a class declaration / abstract / sealed / typedef / extension / library / part / export / import / final / const / var / late
#
# We grep first, then filter out obviously-not-function lines.

LIB_GLOBS=(
  "box_transform/lib/**/*.dart"
  "flutter_box_transform/lib/**/*.dart"
)

FILES=$(find box_transform/lib flutter_box_transform/lib -name '*.dart' | sort)

echo "# Top-level (global) declarations in lib/"
echo
echo "Generated $(date -u +%Y-%m-%dT%H:%M:%SZ) by scripts/find_globals.sh."
echo
echo "Each row is a candidate global function/getter for refactoring into a"
echo "class-scoped static. Verify by hand before moving."
echo

for f in $FILES; do
  # Lines that LOOK like top-level function decls. Excludes:
  #   class / abstract class / sealed class / final class / mixin /
  #   extension / typedef / enum / part / part of / library / import /
  #   export / @<annotation>
  awk '
    BEGIN { in_block_comment = 0 }
    /^\/\*/ { in_block_comment = 1 }
    /\*\// { in_block_comment = 0; next }
    in_block_comment { next }
    /^\/\// { next }
    /^[[:space:]]*$/ { next }
    /^[[:space:]]/ { next }                      # any indented line is class member
    /^class / { next }
    /^abstract / { next }
    /^sealed / { next }
    /^final class / { next }
    /^mixin / { next }
    /^extension / { next }
    /^typedef / { next }
    /^enum / { next }
    /^part / { next }
    /^library/ { next }
    /^import / { next }
    /^export / { next }
    /^@/ { next }
    /^const / { next }
    /^final / { next }
    /^var / { next }
    /^late / { next }
    /^void main\(/ { next }                      # entry point of bench/cli
    /^void mainMethod\(/ { next }
    # A line that has a `(` and a likely identifier prefix.
    /\(/ {
      # Skip pure-statement lines (no identifier-followed-by-paren).
      if ($0 ~ /^[A-Za-z_<>?,[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\(/) {
        printf "%s:%d  %s\n", FILENAME, NR, $0
      }
    }
  ' "$f"
done
