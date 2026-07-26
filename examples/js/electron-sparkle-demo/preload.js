const { contextBridge } = require('electron');
const ffi = require('ffi-napi');
const path = require('path');
const fs = require('fs');

const dylibPath = path.join(__dirname, 'libMacSparkle.dylib');
let native = null;

if (fs.existsSync(dylibPath)) {
  try {
    native = ffi.Library(dylibPath, {
      mac_sparkle_init: ['void', []],
      mac_sparkle_check_update_with_ui: ['bool', []],
    });

    native.mac_sparkle_init();
  } catch (error) {
    console.error('Failed to load libMacSparkle:', error);
  }
} else {
  console.error('libMacSparkle.dylib not found at', dylibPath);
}

contextBridge.exposeInMainWorld('api', {
  checkForUpdate: () => {
    if (!native) {
      throw new Error('libMacSparkle is not loaded');
    }
    return native.mac_sparkle_check_update_with_ui();
  },
});
