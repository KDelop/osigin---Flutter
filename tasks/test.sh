set -x
file=$1

if ! test -z "$1"; then
  found=$(find ./test ./int_test_new -name "$1*.dart" )
fi

shift 

find -name '*.dart' | entr flutter test "${@}" ${found}