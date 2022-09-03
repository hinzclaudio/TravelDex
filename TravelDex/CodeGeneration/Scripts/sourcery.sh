base="$(dirname "$0")/.."
podDir="$(dirname "$0")/../Pods"
sources="$base/../.."
templates="$base/Templates"
generated="$base/Generated"
#visperSources="$podDir/VISPER-Sourcery/VISPER-Sourcery/Classes"
SOURCERY=Pods/Sourcery/bin/sourcery

$SOURCERY --sources $sources  --templates $templates --output $generated --disableCache
