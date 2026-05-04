#!/bin/sh

outputFile="$(pwd)/test/coverage_test.dart"
packageName="$(cat pubspec.yaml | grep '^name: ' | awk '{print $2}')"

printf "/// *** 自動生成ファイル - 更新したい場合は scripts/gen_coverage_test.sh を実行してください *** ///\n" > "$outputFile"
echo "// ignore_for_file: unused_import" >> "$outputFile"
find lib/import -name '*.dart' | awk -v package=$packageName '{gsub("^lib", "", $1); printf("import '\''package:%s%s'\'';\n", package, $1);}' >> "$outputFile"
echo "import 'package:flutter_test/flutter_test.dart';" >> "$outputFile"
printf "\nvoid main() {\n  test('Coverage test imports all packages', () {\n    expect(true, isTrue);\n  });\n}\n" >> "$outputFile"
