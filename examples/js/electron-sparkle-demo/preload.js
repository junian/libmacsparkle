const { contextBridge } = require('electron');
const path = require('path');
const fs = require('fs');

const dylibPath = path.join(__dirname, 'libMacSparkle.dylib');
const frameworkPath = path.join(__dirname, 'Sparkle.framework');

let native = null;
let loadError = null;

if (process.platform === 'darwin') {
  process.env.DYLD_FRAMEWORK_PATH = __dirname;

  if (fs.existsSync(dylibPath) && fs.existsSync(frameworkPath)) {
    try {
      const koffi = require('koffi');
      native = koffi.load(dylibPath);
      
      // Load functions using koffi
      const mac_sparkle_init = native.func('void mac_sparkle_init()');
      const mac_sparkle_check_update_with_ui = native.func('void mac_sparkle_check_update_with_ui()');

      // Initialize Sparkle
      mac_sparkle_init();

      // Store functions for later use
      native.mac_sparkle_init = mac_sparkle_init;
      native.mac_sparkle_check_update_with_ui = mac_sparkle_check_update_with_ui;
    } catch (error) {
      loadError = error;
      console.error('Failed to load libMacSparkle or native bindings:', error);
    }
  } else {
    loadError = new Error(`libMacSparkle.dylib or Sparkle.framework not found in ${__dirname}. Run "npm run copy-native" first.`);
    console.error(loadError.message);
  }
} else {
  loadError = new Error('Electron Sparkle demo only supports macOS');
}

contextBridge.exposeInMainWorld('api', {
  checkForUpdate: () => {
    if (!native) {
      throw loadError ?? new Error('libMacSparkle is not loaded');
    }
    return native.mac_sparkle_check_update_with_ui();
  },
});
