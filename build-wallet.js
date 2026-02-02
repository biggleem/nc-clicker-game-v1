import * as esbuild from 'esbuild';

await esbuild.build({
  entryPoints: ['src/wallet.js'],
  bundle: true,
  format: 'iife',
  outfile: 'dist/wallet.js',
  globalName: 'TonWalletBundle',
  define: {
    'process.env.NODE_ENV': '"production"',
  },
}).catch(() => process.exit(1));
