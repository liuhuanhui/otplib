#!/bin/bash

if [ -z "$OTPLIB_BUILD_CLEAN" ] || [ "$OTPLIB_BUILD_CLEAN" == "true" ]; then
  echo "\n--- cleaning prev builds ---"
  npx rimraf \
    builds/otplib
fi

if [ -z "$OTPLIB_BUILD_MODULE" ] || [ "$OTPLIB_BUILD_MODULE" == "true" ]; then
  echo "\n--- building typedef ---"
  npx tsc \
    --emitDeclarationOnly \
    -p ./configs/tsconfig.json

  echo "\n--- modifying file paths ---"
  node ./scripts/renameDir.js
  node ./scripts/updateContent \
    typedef \
    ./builds/otplib/**/*.d.ts

  echo "\n--- build modules ---"
  NODE_ENV=production npx rollup \
    -c ./configs/rollup.config.js
fi

if [ -z "$OTPLIB_BUILD_BUNDLE" ] || [ "$OTPLIB_BUILD_BUNDLE" == "true" ]; then
  echo "\n--- build bundles ---"
  NODE_ENV=production npx webpack \
    --config ./configs/webpack.config.js
fi

if [ -z "$OTPLIB_BUILD_DOWNLOAD_BUFFER" ] || [ "$OTPLIB_BUILD_DOWNLOAD_BUFFER" == "true" ]; then
  echo "\n--- downloading buffer module ---"
  curl https://bundle.run/buffer@5.3.0 \
    --output ./builds/otplib/preset-browser/buffer.js
fi

if [ -z "$OTPLIB_BUILD_COPY_META" ] || [ "$OTPLIB_BUILD_COPY_META" == "true" ]; then
  echo "\n--- copying meta ---"
  cp ./README.md ./builds/otplib/README.md
  cp ./LICENSE ./builds/otplib/LICENSE
  cp ./package.json ./builds/otplib/package.json
  cp ./.npmignore ./builds/otplib/.npmignore
fi
