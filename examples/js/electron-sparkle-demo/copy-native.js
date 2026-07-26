const path = require('path');
const fs = require('fs');
const { execSync } = require('child_process');

const repoRoot = path.resolve(__dirname, '..', '..', '..');
const buildReleasePath = path.join(repoRoot, '.build', 'release');
const dylibPath = path.join(buildReleasePath, 'libMacSparkle.dylib');
const frameworkPath = path.join(buildReleasePath, 'Sparkle.framework');
const targetDir = path.join(__dirname);

console.log('Copying native libraries...');

// Check if build directory exists
if (!fs.existsSync(buildReleasePath)) {
  console.error(`Build directory not found at ${buildReleasePath}`);
  console.error('Please run ./build.sh in the repository root first');
  process.exit(1);
}

// Copy dylib
if (fs.existsSync(dylibPath)) {
  const targetDylib = path.join(targetDir, 'libMacSparkle.dylib');
  fs.copyFileSync(dylibPath, targetDylib);
  console.log(`✓ Copied libMacSparkle.dylib to ${targetDylib}`);
} else {
  console.error(`libMacSparkle.dylib not found at ${dylibPath}`);
  process.exit(1);
}

// Copy Sparkle.framework
if (fs.existsSync(frameworkPath)) {
  const targetFramework = path.join(targetDir, 'Sparkle.framework');
  
  // Remove existing framework if it exists
  if (fs.existsSync(targetFramework)) {
    fs.rmSync(targetFramework, { recursive: true, force: true });
  }
  
  // Copy framework recursively
  execSync(`cp -R "${frameworkPath}" "${targetDir}"`, { stdio: 'inherit' });
  console.log(`✓ Copied Sparkle.framework to ${targetFramework}`);
} else {
  console.error(`Sparkle.framework not found at ${frameworkPath}`);
  process.exit(1);
}

console.log('Native libraries copied successfully!');
