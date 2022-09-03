if [[ -f "${PODS_ROOT}/SwiftGen/bin/swiftgen" ]]; then
  "${PODS_ROOT}/SwiftGen/bin/swiftgen"
else
  echo "warning: SwiftGen is not installed. Run 'pod install --repo-update' to install it."
fi